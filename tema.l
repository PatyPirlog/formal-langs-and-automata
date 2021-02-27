/* Pirlog Patricia-Claudia 332CC - TemaB */
/* Mai multe detalii despre implementare in README.txt */
%{
    #include<stdio.h>
    #undef yywrap
    int spaces = 0;

    void printSpaces(int spaces) {
        for(int i = 0; i < spaces; i++) {
            printf(" ");
        }
    }
%}
/* Stari folosite */
%s IN_ELEMENT ATTRIBUTES DOTS 
%x VALUE

/* Reguli de formare pentru elemente, atribute si valorile lor */
Str [a-z:]*
Atr {Str}[ ]?[=]
Text [A-Za-z0-9 =?:%#;@$()*~`/.-]*
/* Reguli de inceput si sfarsit pentru tag-uri acceptate si neacceptate */
Begin [<]
End [>]
ClosedTag [/][ ]?[>]
NotPermitedBegin "<!"|"<?"
NotPermitedTag {NotPermitedBegin}{Text}{End}
NotPermited [?!]
BreakInText "br"[ ]?
Backslash [/]
/* Reguli pentru elemente */
Start {Str}
StartWithArgs {Str}[ ]?
Equal [ ]?[=]
/* Reguli pentru valori */
Quote [ ]?["]

/* Caut tag-uri valide, trecand prin mai multe stari, pe care le analizez */
/* Printez un tag parsat in functie de regulile specifice */
/* Printez nr de spatii necesar pt imbricare cu functia printSpaces() */
%%
{NotPermitedTag} ;
<INITIAL>{Begin} {BEGIN IN_ELEMENT;}
<IN_ELEMENT>{Backslash} {spaces--; BEGIN INITIAL;}
<IN_ELEMENT>{NotPermited} {BEGIN INITIAL;}
<IN_ELEMENT>{BreakInText} {printSpaces(spaces); ECHO; printf("\n"); BEGIN INITIAL;}
<IN_ELEMENT>{Start} {printSpaces(spaces); ECHO; BEGIN ATTRIBUTES; spaces++;}
<IN_ELEMENT>{StartWithArgs} {printSpaces(spaces); ECHO; printf(":: "); BEGIN ATTRIBUTES; spaces++;}
<ATTRIBUTES>{Atr} {yyless(yyleng - 1); BEGIN DOTS; ECHO;}
<ATTRIBUTES>{End} {printf("\n"); BEGIN INITIAL;}
<ATTRIBUTES>{ClosedTag} {printf("\n"), spaces--; BEGIN INITIAL;}
<DOTS>{Equal} {printf(" :"); BEGIN VALUE;}
<VALUE>{Quote} {printf(" ");}
<VALUE>{Text} {ECHO; printf(" ; "); BEGIN(ATTRIBUTES);}
.|"\n" ;
%%

char **ListaFisiere;
unsigned int FisierCurent = 0;
unsigned int NumarFisiere;

/* Codul (inclusiv in main) din curs, folosit pentru citirea unui singur fisier */
int yywrap() {
    FILE *fisier = NULL;

    fclose(yyin);
    FisierCurent++;

    if(FisierCurent >= NumarFisiere)
        return 1;
    fisier = fopen(ListaFisiere[FisierCurent], "r");
    if(!fisier) {
        printf("!!!eroare!!!");
        exit(1);
    }

    yyin = fisier;
    return(fisier ? 0:1);
}

int main(int argc, char **argv) {
    FILE *fisier;
    ListaFisiere = argv + 1;
    NumarFisiere = argc - 1;

    if(argc > 1) {
        FisierCurent = 0;
        fisier = fopen(ListaFisiere[FisierCurent], "r");

        if(!fisier) {
            printf("!!!eroare!!!");
            exit(1);
        }

        yyin = fisier;
        yylex();
    }
}