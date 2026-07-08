/// Mszentpeteriova 2026
/// jednoducha konzolova kalkulacka
/// pouzite online manualy, znalosti(z poznamok/uloh/projektov a predmetu Programovanie 2 od Mgr. Michal Vagač, PhD. a Ing. Lucia Ondrigová, PhD.)
///  ako funguje:
/// nacita dve cisla (a a potom b) od pouzivatela
/// pouzivatel si vyberie operaciu
/// na cisla sa aplikuje dana matematicka operacia
/// vypise sa na konzolu vysledok


import java.util.Scanner;
// trieda Scanner nam umoznuje podobne ako:
// v C - scanf()
// v python - input()
// pristup k metodam pre vstup z konzoly
// Zdroj(viac na): https://www.itnetwork.sk/java/zaklady/parsovanie-hodnot-v-jave

public class Kalkulacka {
    public static void main(String[] args) {
        Scanner konzola = new Scanner(System.in);
        // vytvorime si instanciu objektu (vstavanej treiedy Scanner)
        // pricom si nazveme premennu tiez scanner
        // a do instancie si dame ako argument - co objekt bude robit:
        // - nacitavat vstup(=input) - preto System.in

        System.out.println("=== SIMPLE CALCULATOR ===");
        // podobne ako v C print("text\n") nam aj println zabezpeci vypis so zalomenim riadku
        // naopak obycajny print vypise na konzolu bez lomenia riadku

        System.out.print("Zadajte prve cislo (desatinnu ciarku miesto bodky ak je cislo desatinne - napr. 10,05): ");
        double a = konzola.nextDouble();
        // nas objekt konzola tu zabezpeci ze sa caka na pouzivatela kym stlaci enter
        // zadane cislo (moze byt aj desatinne, kedze je pouzity typ double)
        // program ulozi vstup do premennej s nazvom a, s ktorou potom dalej

        // co je metoda nextDouble() v - typ premenna = objekt.nextTYP()?
        // "kedze nam IntelliJ niekedy doplna veci bez toho aby sme vedeli presne preco co to je?"
        // viac na: https://www.w3schools.com/java/ref_scanner_nextdouble.asp
        //          vo vyhladavaci popis priamo pod strankou: Java Scanner Nextdouble() method - Naukri Code 360
        //          kedze link na danu stranku je nedostupny z IP https://www.naukri.com/code360/library/java-scanner-nextdouble-method
        // precita dalsi token(sekvenciu suvisiacich znakov/cisel oddelenych symbolmi)
        // zo vstupu ako hodnotu s pohyblivou desatinnou ciarkou (float/floating point)
        // - s dvojitou presnostou

        System.out.print("Zadajte druhe cislo (desatinnu ciarku miesto bodky ak je cislo desatinne - napr. 10,05): ");
        double b = konzola.nextDouble();

        System.out.println("\nVyberte si matematicku operaciu (vo forme daneho cisla - napr. 1):");
        System.out.println("1. +");
        System.out.println("2. -");
        System.out.println("3. *");
        System.out.println("4. /");

        System.out.print("Vas vyber: ");
        int vyber = konzola.nextInt();

        double vysledok = 0;
        String znamienko = "";
        // pred pouzitim nam treba premenne inicializovat
        // takto zabezpecime ze mame pristupne prazdne/pouzitelne premenne
        // pre ciselne typy staci 0, pre retazce ale treba "" = prazdny retazec

        switch (vyber) {
            // podobne ako v python/c pouzijeme prepinac moznosti(=switch)
            // aj s predvolenym vyberom(=default) ak by ziadna z moznosti nebola vybrata
            case 1:
                vysledok = a + b;
                znamienko = " + ";
                break;
                // break nam tiez rovnako zabezpeci "vyskocenie" z moznosti o "uroven" VYSSIE
            case 2:
                vysledok = a - b;
                znamienko = " - ";
                break;
            case 3:
                vysledok = a * b;
                znamienko = " * ";
                break;
            case 4:
                if (b != 0) {
                    vysledok = a / b;
                    znamienko = " / ";
                    // ak druhe cislo nieje "0"
                    // znamena to ze sa nedelilo nulovym cislom
                } else {
                    System.out.println("Delenie nulou nieje možné!");
                    // ak sa predsalen delilo cislom "0" vypise chybove hlasenie
                    konzola.close();
                    return;
                }
                break;
            default:
                System.out.println("Neplatný pokus!");
                konzola.close();
                return;
        }

        System.out.println("Vysledok vášho príkladu " + a + znamienko + b + " je = " + vysledok);

        konzola.close();
    }
}
