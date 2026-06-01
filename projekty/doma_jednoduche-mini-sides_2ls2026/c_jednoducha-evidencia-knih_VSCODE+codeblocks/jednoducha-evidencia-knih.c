// Mszentpeteriova 2026
// mini evidencia knih
// vyuzitie nadobudnutych vedomosti a materialov(domacich uloh/testov) z predmetu:
// Algoritmy a Struktury udajov 1, 2 od PaedDr., Mgr. Vladimíra Siládiho, PhD.
// v smere praca so subormi, pridavanie, odstranovanie vecí
// pouzitie dostupnych informaci o pouziti jednotlivvych kniznic/funkcii/prikazov
// v pripade ze sa nenachadzali v starych materialoch z:
// https://www.itnetwork.sk/cecko/subory/c-tutorial-pracu-s-textovymi-subormi


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_KNIH 100
// definovanie MAKRA aby sme rovno videli co za udaj pouzivame v cykle/podmienke

/* STRUKTURA ktora nam opisuje/definuje jednu knihu */
typedef struct{
    char isbn[20];
    // cisla su vysie pre pripady dlhych nazvov/mien/ciselnych sekvencii
    char nazov[100];
    char autor[100];
    int rok;
}Kniha;

/**================
 * CO PROGRAM ROBÍ:
 * ================
 * Nacita knihy zo suboru.
 * Format riadku predpokladame ze je:
 * ISBN;Nazov;Autor;Rok
 */

 void nacitajKnihy(const char *cesta, Kniha knihy[], int *pocetKnih){
    // nezabudame ze argumenty fcie void maju v jazyku C vzdy TYP (integer/character/atd)
    // (ukazovatel na konstantny znak/retazec, premenna (v nasom pripade typu struktura), ukazovatel na pocet knih)
    // konstantny = fciaa nesmie meniť obsah reťazca

    FILE *subor = fopen(cesta, "r");
    // subor otvorime  na "r = reading" = citanie

    if (subor == NULL){
        // ak subor neexistuje - vypise nam chybove hlasenie
        printf("Subor sa nepodarilo otvorit. Skúste znova.\n");
        return;
        // vdaka return sa program dalej nevykonava - vyhodi nas z neho

    }
    // ak nemame explicitne danu else vetvu, a chyba nenastala,
    // program pokracuje dalej

    char riadok[300];

    while(fgets(riadok, sizeof(riadok), subor)){
        //  fcia fgets bezpecne nacitava textove retazce
        // ma parametre:
        // (do coho nacitava/nejaky kvazi "buffer", akej velkosti retazec nacitava, a z coho nacitava)
        // v pripade nejasnosti viac na: https://en.wikibooks.org/wiki/C_Programming/stdio.h/fgets

        char *token;

        token = strtok(riadok, ";");
        // fcia strto(co je rozdelovane, "rozdelovac"):
        // sa rozdeli nas riadok na mensie tzv. "tokeny" (casti ktore spolu suvisia = tj nase nazvy/ISBN/atd)
        // - znalosť názvu z časti lexikálna analýza z predmetu Počítačové systémy 2 od Mgr. Michal Vagač, PhD.
        // viac na: https://cs.wikipedia.org/wiki/Lexik%C3%A1ln%C3%AD_anal%C3%BDza
        // prave preto, aby sa nemuselo robit vetvenie (if/else) zo zistovanim kde sa nachadza oddelovac, ked nan narazi bude hned vediet "aha novy token"


        if (token == NULL) continue;
        // ak je prazdny token pokracuje v programe dalej
        strcpy(knihy[*pocetKnih].isbn, token);
        // kopiruje prvy token (zdrojovy retazec) na adresu knihy[index v poli].isbn - nase isbn
        // viac na: https://www.w3schools.com/c/ref_string_strcpy.php
        //          sekcia Štruktúry obr.2 na: https://www.itnetwork.sk/cecko/zaklady/tutorial-jazyk-c-struktury

        //toto opakujeme tolko krat, kolko mame udajov o knihe
        token = strtok(NULL, ";");
        // viac na: https://stackoverflow.com/questions/3889992/how-does-strtok-split-the-string-into-tokens-in-c
        //          https://www.ibm.com/docs/en/i/7.4.0?topic=functions-strtok-tokenize-string
        // kedze v citani pokracuje, uz sa vieme ze pokracujeme v citani "riadok"
        // inak by sa citalo vsetko od zaciatku riadku - preto je prvy atribut nedefinovany=NULL

        if (token == NULL) continue;
        strcpy(knihy[*pocetKnih].nazov, token);
        // kopiruje na adresu knihy[index].nazov - nas nazov

        token = strtok(NULL, ";");
        if (token == NULL) continue;
        strcpy(knihy[*pocetKnih].autor, token);
        // kopiruje na adresu knihy[index].autor - naseho autora

        token = strtok(NULL, "\n");
        // tu je nas oddelovac "zalomenie/koniec riadku"
        if (token == NULL) continue;
        knihy[*pocetKnih].rok = atoi(token);
        // kopiruje na adresu knihy[index].autor - naseho autora
        // fcia atoi - pretypuje ascii znaky na integer (cele cisla)

        (*pocetKnih)++;
        // zvysime pocet knih = index pola
    }
    fclose(subor);
    // vzdy po otvoreni suboru a skonceni jeho pouzitia:
    // je ho potrebne ZATVORIT

    printf("Nacitanych knih je momentalne: %d\n", *pocetKnih);
}

/**int i = 0
 * Tato fcia vypise vsetky knihy nacitane v pamati
 */
void zobrazKnihy(Kniha knihy[], int pocetKnih){
    // opat mame dane parametre (typ pole_knih_z-kade-citam[], pocet knih - kolko  ich citam = kedy konci citanie (nas cyklus))
    // (v com hladam=v poli, kde hladam=na akom indexe v poli)

    if(pocetKnih == 0){
        // ak nenacitalo knihy - vypise chybove hlasenie
        printf("Ziadne knihy niesu evidovane.\n");
        return;
    }

    printf("\n====ZOZNAM KNIH====");

    for(int i = 0; i < pocetKnih; i++){
        // po poli sa pohybujeme pomocou pocitadla/indexu i
        printf("\nKniha %d\n", i + 1);
        // podobne ako v pythone
        // (tu moznost vypisu bez TYPOV v style print(f"{premenna}") neexistuje)
        // musime print/vypis pisat ako ("text %typ", premenna) - v nasom pripade:
        // ("text: %typ\lomenieRiadku", pole[index].covypisujemPremenna)
        printf("ISBN: %s\n", knihy[i].isbn);
        printf("Nazov: %s\n", knihy[i].nazov);
        printf("Autor: %s\n", knihy[i].autor);
        printf("Rok: %d\n", knihy[i].rok);
    }
}


/**
 * Tato fcia vyhlada knihu podla ISBN
 * Vrati index knihy alebo ze chyba = cislom -1
 */
int najdiISBN(Kniha knihy[], int pocetKnih, const char *isbn){
    // kedze nam fcia nieco vracia - musime ju dat typu int (miesto void)
    // opat mame parametre (typ  pole[], typ  pocet, ukazovatel na konstantnu premmennu isbn)
    // (v com hladam=poli, kde hladam=na akom indexe, s cim porovnavam=so stalou(nemennou) premennou isbn)
    for(int i = 0; i < pocetKnih; i++){
        if(strcmp(knihy[i].isbn, isbn) == 0){
            // fcia strcmp(stringcompare) nam porovna ci sa "KLUCE" - veci ktore porovnavame
            // zhoduju, ak ano - naslo knihu = vrati jej index
            return i;
        }
    }
    return -1;
    // ak knihu nenajde vrati chybu = cislo -1
    // musime dat az za cyklom
}

/**
 * Tato fcia prida novu knihu
 * Kontroluje ci knihy nemame podvojmo ulozene - (rovnake isbn a vsetky ostatne udaje)
 */
void pridajKnihu(Kniha knihy[], int *pocetKnih){
    // opat parametre (typ pole[], ukazovatel na pocet knih)
    // (kde to pridavam=pole, do coho=na dany index)

    if(*pocetKnih >= MAX_KNIH){
        // ak mame pole knih plne - vypise nam chybove hlasenie
        printf("Databaza je plna.\n");
        return;
    }

    Kniha nova;

    printf("ISBN: ");
    fgets(nova.isbn, sizeof(nova.isbn), stdin);
    // cez fciu fgets pouzivatel prida knihu
    // (kde.coPridavam, akejVelkosti(kde.coPridavam), co robim - standardInput=vkladam)
    // najprv isbn - podla toho zisti ci kniha uz neexistuje
    // ak existuje - pouzivatelovi neumozni pridat knihu
    nova.isbn[strcspn(nova.isbn, "\n")] = '\0';
    // odstrani nam znak noveho riadku/zalomenia riadku z konca retazca(napr. nasej premennej nova.nazov)
    // - vyhlada v retazci prvy vyskyt znaku lomenia riadku,
    // - vrati jeho index
    // - a na dany index vlozi "nulovy terminator" = ukoncovaci znak retazca

    if(najdiISBN(knihy, *pocetKnih, nova.isbn) != -1){
        // ak knihu najde vypise chybove hlasenie
        printf("Kniha s tymto ISBN uz existuje.\n");
        return;
    }

    printf("Nazov: ");
    // ak kniha neexistuje - pouzivatelovi umozni ju pridat
    fgets(nova.nazov, sizeof(nova.nazov), stdin);
    // cez fciu fgets (kde.co, velkost(coho), co-robime/standardny vstup=vstup pouzivatela cez konzolu)
    nova.nazov[strcspn(nova.nazov, "\n")] = '\0';

    // toto opat robime pre kazdy udaj knihy

    printf("Autor: ");
    fgets(nova.autor, sizeof(nova.autor), stdin);
    nova.autor[strcspn(nova.autor, "\n")] = '\0';

    printf("Rok vydania: ");
    scanf("%d", &nova.rok);
    // kedze tu ziskavame udaj bez medzier - rok
    // staci nam vyuzit pre nacitanie vstupu
    // fcia scanf("%typ", apersand-ak-pracujeme-s-integeromKDE.co)
    getchar();
    // pouzivatel napise: napr. 1 ENTER
    // scanf precita: 2020
    // getchar precita: ENTER
    // pouzivame tu getchar na precitanie+odstranenie stlaceneho enteru zo vstupu z konzoly
    // viac na: https://programovani.uzlabina.cz/ccpp:getchar

    knihy[*pocetKnih] = nova;
    // do naseho pola vlozime novu knihu ktoru sme si vytvorili
    (*pocetKnih)++;
    // a posunieme pointer/ukazovatel na dalsiu adresu pola

    printf("Kniha bola pridana.\n");
}


/**
 * Tato fcia odstrani knihu podla ISBN
 */
void odstranKnihu(Kniha knihy[], int *pocetKnih){
    // opat parametre (Typ pole[], pozicia v poli)
    // (do coho vkladam, na aku poziciu/kde vkladam)
    char isbn[20];
    // toto je nas kluc
    // podla tohto sa najde existujuce ISBN - porovna
    // - a ak sedi vymaze sa kniha s danym ISBN
    printf("Zadajte ISBN knihy na odstranenie: ");

    fgets(isbn, sizeof(isbn), stdin);
    // opat (co vkladam, akejVelkosti(co), co-robim_standardny-vstup-na-konzolu)
    isbn[strcspn(isbn, "\n")] = '\0';
    // opat - znak zalomenia sa meni za znak konca retazca

    int index = najdiISBN(knihy, *pocetKnih, isbn);
    // volanie nasej fcie najdiISBN(v com=pole knihy, *kde=adresa, co=isbn)

    if(index == -1){
        printf("Kniha s tymto ISBN neexistuje.\n");
        // ak knihu nenajde vypise chybove hlasenie
        return;
    }

    for(int i = index; i < (*pocetKnih - 1); i++){
        // ide len po *pocetKnih - 1 lebo to je posledny prvok pola
        knihy[i] = knihy[i+1];
        // tam kde knihu najde - tak ju len vyhodi z pola tzv. ZA jeho "koniec"
    }

    (*pocetKnih)--;
    // zmensi obsadenost pola (o jednu adresu zaplnenu menej)

    printf("Kniha bola odstranena.\n");
}


/**
 * Tato fcia ulozi aktualny zoznam knih do suboru
 * a prepise ho
 */
void ulozKnihy(const char *cesta, Kniha knihy[], int pocetKnih){
    // opat parametre (pointer na konstantnu premennu cesta=kde je subor/ukladame/piseme, z kade, kolko)
    FILE *subor = fopen(cesta, "w");
    // otvorime si nas subor s knihami na zapisovanie/prepisanie

    if(subor == NULL){
        // ak sa subor nenasiel vypise chybove hlasenie
        printf("Nepodarilo sa zapisat do suboru.\n");
        return;
    }

    for(int i = 0; i < pocetKnih; i++){
        // ak subor existuje prepiseme ho
        fprintf(
            subor,
            // kde zapisujem
            "%s;%s;%s;%d\n",
            // akym stylom/formatom
            // u nas je riadok v style "%typ;%typ...\n"
            knihy[i].isbn,
            // co sa za dane typy do retazca dosadi
            knihy[i].nazov,
            knihy[i].autor,
            knihy[i].rok
        );
    }

    fclose(subor);
    // ako uz vieme z hornej casti:
    // vzdy ked subor OTVORIME treba ho aj ZAVRIET
    printf("Zmeny boli ulozene.\n");
}


/**
 * Toto je hlavna fcia
 * Nas program - ktory vsetko spusta
 */
int main(){
    Kniha knihy[MAX_KNIH];
    // inicializujeme si pole a index/ukazovatel poctu knih
    int pocetKnih = 0;

    char cesta[200];
    // to iste urobime aj pre cestu k suboru
    while(1){
            // nekonecny cyklus pre pripad ze pouzivatel zadal zle cestu k suboru/subor sa nenasiel
        printf("Zadajte cestu k suboru: ");
        fgets(cesta, sizeof(cesta), stdin);
        cesta[strcspn(cesta, "\n")] = '\0';
        // odstranime zalomenie riadku - kedze pouzivatel po zadani stlaci enter

        FILE *test = fopen(cesta, "r");
        // otvorime subor ako test - len na citanie

        if(test != NULL){
            fclose(test);
            // ak sa subor otvoril uspesne vyskocime t nekonecneho cyklu
            break;
        }

        int volba;
        // ak sa neotvoril poziju sa moznosti prepinaca(=switch)
        // kde si pouzivatel moze vybrat ci sa pokusi znova alebo program vypne
        // - a vytvori/najde si subor vo vlastnom zaujme

        printf("Subor sa nepodarilo otvorit.\n");
        printf("1. Skusit znova\n");
        printf("2. Ukoncit program\n");

        scanf("%d", &volba);
        getchar();
        // fcia getchar na odstranenie enteru za vstupom z klavesnice od pouzivatela

        if(volba == 2){
            return 0;
            // ak si pouzivatel vyberie volbu 2
            // program sa uspesne ukonci
        }
    }
    nacitajKnihy(cesta, knihy, &pocetKnih);
    // zavolame nasu fciu (cesta-k-suboru, co-nacitavame, kolko-toho-nacitavame)

    int volba;
    // inicializujeme si premennu pre volbu pouzivatela v jednoduchom menu
    // - kde si bude vyberat co chce prave robit

    do{
        printf("\n=================\n");
        printf(" Inventar knih\n");
        printf("\n=================\n");
        printf("1. Zobrazte knihy\n");
        printf("2. Pridajte knihu\n");
        printf("3. Odstrante knihu\n");
        printf("4. Ulozte zmeny\n");
        printf("5. Koniec programu\n");

        printf("Zadajte vasu volbu (v tvare - zvolene_cislo = napr. 1): ");
        scanf("%d", &volba);
        printf("DEBUG: volba = %d\n", volba);
        getchar();

        // pouzivatel napise: napr. 1 ENTER
        // scanf precita: 2020
        // getchar precita: ENTER
        // pouzivame tu getchar na precitanie+odstranenie stlaceneho enteru zo vstupu z konzoly

        switch(volba){
            // tato fcia funguje podobne ako vetvenie ale ma kratsi zapis
            // staci nam napisat moznosti medzi ktorymi bude:
            // prepinat(=switch)
            case 1:
                zobrazKnihy(knihy, pocetKnih);
                break;
                // akonahle sa fcia vykona
                //- prikaz break nas vyhodi o uroven vyssie = da nas von z danej moznosti

            case 2:
                pridajKnihu(knihy, &pocetKnih);
                break;

            case 3:
                odstranKnihu(knihy, &pocetKnih);
                break;

            case 4:
                ulozKnihy(cesta, knihy, pocetKnih);
                break;

            case 5:
                printf("Program ukonceny.\n");
                break;

            default:
                printf("Neplatna volba.\n");
                // ak ziadna volba nieje vyuzita
                // musime si definovat aj pripad predvolenej moznosti
        }
    }while(volba != 5);
    // cyklus DO sa bude vykonavat kym pouzivatel nezada volbu 5 = ukoncenie programu
    return 0;
    // ak prgram "zbehne a skonci uspesne" - vypise nam na konzolu "0"
}
