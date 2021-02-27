/* -- Pirlog Patricia-Claudia 332CC - TemaB -- */

* R <Nume> = Regula <Nume>

Pentru a implementa tema, am pornit initial de la codul de citire din fisier prezentat la curs.
Pentru rulare doar pe un singur fisier, dupa executia make build se va folosi urmatoarea linie in terminal: 
	./a.out input.txt
Unde input.txt poate fi orice fisier de input .html(.txt)
(cele din exemple + cele 2 adaugate)
Tin sa specific ca la rularea make run pe PC-ul personal, output-ul va fi afisat pentru toate testele in terminal, icorect.

Pentru a avea output-ul specificat in exemple, am folosit 5 stari:
INITIAL, IN_ELEMENT, ATTRIBUTES, DOTS, VALUE. Folosesc de asemenea o constanta spaces pe care o incrementez sau decrementez in functie de spatiile necesare pt a indica gradul de imbricare al unui element(initial 0). Am functia printSpaces care imi printeaza spatiile necesare.
in starea INITIAL:
	R {Begin} -- Verific ca am un inceput de tag ("<") pentru a analiza ce se afla in interiorul acestuia si daca gasesc, trec in starea IN_ELEMENT
in starea IN_ELEMENT:
	--R {Backslash} -- am gasit un tag de final deci scad numarul de spatii deoarece gradul de imbricare pentru urmatorul tag va fi mai mic cu 1; trec in starea initial pentru a cauta din nou un tag de inceput.
	--R {NotPermited} -- gasesc dupa "<", ori "!" sau "?" pe care le ignor si trec iar in starea INITIAL.
	--R {BreakInText} -- gasesc un tag <br/> sau <br />, deci e un paragraf pe mai multe linii pentru care nu trebuie sa cresc numarul de spatii. Printez spatiile necesare, afisez tagul urmat de "\n" si ma intorc iar in starea INITIAL
	--R {Start} -- gasesc un inceput de element ce stiu ca nu ca avea spatiu dupa, deci nu are argumente. Intai printez spatiile necesare imbricarii, printez elementul, apoi trec in starea ATTRIBUTES si cresc numarul de spatii.
	--R {StartWithArgs} -- gasesc un inceput de element ce are spatiu dupa, deci va avea argumente. Printez spatiile, apoi elementul, apoi ":: ", trec in starea ATTRIBUTES, si cresc nr de spatii.
in starea ATTRIBUTES:
	-- stare folosita pentru analiza argumentelor dintr-un tag permis
	R {Atr} -- daca gasesc un atribut de forma "nume=" cu yyles ma pozitionez pe egal pe care il voi inlocui ulterior in starea DOTS cu ":"; printez argumentul fara "="
	R {End} -- daca am gasit sfarsitul unui tag ">", printez un "\n" si ma intorc in starea initial de unde incep iar cautarea pentru tag-uri.
	R {ClosedTag} -- Daca gasesc un tag care se deschide si se si inchide de forma < ... />, pe urmatorul tag voi fi pe acelasi nivel de imbricare, deci trebuie sa scad numarul de spatii pentru a ma asigura de acest lucru(spaces initial fiind incrementat de una din regulile de start din IN_ELEMENT)
in starea DOTS:
	-- R {Equal} -- inlocuiesc egalul din atribut cu " :" si trec in starea VALUE
in starea VALUE
	-- R {Quote} -- daca gasesc ", atunci printez un spatiu
	-- R {Text} -- daca agsesc un text, atunci il afisez, printez ";" pentru a desaprti perechea argument-valoare de urmatoarele, si ma intorc in starea ATTRIBUTES pentru a vedea daca mai gasesc alte atribute in tag-ul respectiv.

.|"\n" pentru toate starile, daca gasesc orice caracter ce nu ma intereseaza sau "\n", ignor.
Am si regula {NotPermitedTag} folosita pentru a ignora, la fel ca regula {Not Permited} din IN_ELEMENT, tag-urile nepermise.
