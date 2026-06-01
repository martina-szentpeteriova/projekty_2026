# MSzentpeteriova 2026
# generator QR kodu - v2.0 (rozsirene zakladne telo pre generator o istoriu)
# generator - pouzity na generovanie QR kodov na papierovu formu zivotopisu

# co treba najskor:
# instalovat packages buď - cez windows cmd/windows powershell/git bash
#                  ako - pip install qrcode nasledne os a nakoniec datetime
#                alebo - pip install "qrcode[pil]" (ma aj zavislost na kniznicu pillow)
#                                                  (na generovanie obrazkov - ak by sme nemali)
#                 alebo - cez PyCharm - ikonka vľavo "python packages" - a do hladacika vpisat:
#                                                                      - qrcode
#                                                            a stiahnut najnovsiu verziu
#                                (po kliknuti na nu sa vam nad nou zobrazi popup s verziami)
#                                (a na pravej strane readme príručka s potrebnými informáciami)

# VYSLEDNY PROCES/POSTUPNOST PROGRAMU:
# menu()
#    ↓
# generuj_QR()
#    ↓
# uloženie QR
#    ↓
# po_generovani_menu()
#    ↓
#  ├── 1 → return → späť do menu
#  └── 2 → exit → koniec programu

import qrcode
import os
# v pripade nejasnosti ohľadom knižnice os (funkcionalít závislých na operačnom systéme)
#                           (v našom prípade systémový čas počítača - pre našu históriu)
# viac na: https://realpython.com/ref/stdlib/os/
from datetime import datetime
# v pripade nejasnosti ohľadom knižnice datetime (funkcii manipulujúcich s časom a dátumami)
#                           (v našom prípade časová stopa/timestamp vytvorenia daného QR)
# viac na: https://realpython.com/ref/stdlib/datetime/


QR_ADRESAR = "generovane_QR"
# v pripade ak adresar / cesta k adresaru nieje vytvorena - vytvori sa
HISTOR_SUBOR = "generovane_QR/historiaQR.txt"
# tento subor bude nasim vystupom pre casy jednotlivych generovani QR kodov
# lomku naopak davame kvoli tomu ze backslash \ je znak
# ktory zvycajne v kode znaci s nejakým písmenom napr. lomenie riadku - \n

def vytvor_adresary():
    if not os.path.exists(QR_ADRESAR):
        os.makedirs(QR_ADRESAR)
        # ak nieje vytvoreny adresar, vytvori sa

def uloz_historiu(data, naz_suboru):
    # def nazov_fcie(co ma ulozit, kde to ma ulozit)
    with open(HISTOR_SUBOR,"a", encoding="utf-8") as subor:
        # fcia otvor subor(subor, co s nim chceme robit, UTF kodovanie suboru)
        # "a" funguje tak ze ak subor existuje zapisuje na jeho koniec ak nie vytvori ho
        # v pripade nejasnosti viac na: https://www.geeksforgeeks.org/python/difference-between-modes-a-a-w-w-and-r-in-built-in-open-function/

        cas_stopa = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
        # ulozi nam do premennej casovu stopu v danom formate (den/mesiac/rok hodina/minuta/sekuda)
        # viac na: https://www.geeksforgeeks.org/python/python-strftime-function/

        subor.write(f"[{cas_stopa}] {naz_suboru} -> {data}\n")
        # toto nam pomocou funkcie write zapise do suboru nase historie
        # formát zapisu f"{premenna}" sa pouziva najma kvoli lahsiemu zapisu nez obycajny:
        # "text %typ", premenna (ako sa zvykne aj pri vypisoch/print() používať)
        # viac na: https://www.w3schools.com/python/python_file_write.asp

def generuj_QR(data):
    if not data.strip():
        # skontroluje ci ste zadali vstup kktory ocisti o priipadne medzery na zaciatku a konci
        # viac na: https://www.w3schools.com/PYTHON/ref_string_strip.asp
        print("Chyba!: Pre generovanie QR, musíte zadať vstup (text/URL)! \n")
        return

    naz_suboru = input("Zadajte nazov suboru/obrazku QR (bez pripony .png): ").strip()
    # opät nam fcia strip() ocisti vstup od medzier na zaciatku a konci

    if not naz_suboru:
        print("Chyba!: Pre uloženie QR, musíte zadať názov súboru! \n")
        return

    cesta_Ksuboru = os.path.join(QR_ADRESAR, naz_suboru + ".png")
    # toto nam ulozi QR kod do vytvoreneho adresara so zadanym menom a spravnou priponou
    # ak by ste si to chceli uložiť inde, stačí pred adresar pridať cestu do vami zvoleného adresára
    # napr. ak mate ("C:\Users\VASEKONTO\Downloads\projektpython\QR_ADR\qrcode.png"):
    # tak pred QR_ADRESAR pridate ("C:\Users\zvysok cesty\QR_ADR\subor")
    # ak cestu neoznate mozete si ju vypisat cez:
    # print()
    # viac na: https://www.geeksforgeeks.org/python/python-os-path-join-method/

    qr = qrcode.QRCode(
        version=1,
        # tato verzia vytvori maticu o velkosti 21x21
        box_size=10,
        # velkost kazdeho stvorca/boxu v pixeloch
        border=4,
        # hrubka ohranicenia okolo QR kodu
        # viac na: sekcia Parameters na https://www.geeksforgeeks.org/python/generate-qr-code-using-qrcode-in-python/
    )

    qr.add_data(data)
    # prida data ktore ma spracovat do QR kodu

    qr.make(fit=True)
    # automaticky vypocita a nastavi:
    # najmensiu moznu velkost QR kodu tak
    # aby sa tam pomestili vsetky nase ulozene data - napr. pri URL - vsetky symboly


    obr = qr.make_image(fill_color="black", back_color="white")
    # vytvori nas QR kod cierny s bielym pozadim

    obr.save(cesta_Ksuboru)
    # kde sa ulozi nas QR kod

    uloz_historiu(data, naz_suboru + ".png")
    # ulozi nasu historiu pre vypisy
    # a to vo forme (co ukladam, kde/do coho to ukladam)

    print(f"\n QR kód bol uložený: ")
    print(cesta_Ksuboru)
    po_prvejMoznosti_menu()

def ukaz_historiu():
    if not os.path.exists(HISTOR_SUBOR):
        print("\nZatiaľ neexistuje história.")
        return

    print("\n===HISTÓRIA GENEROVANIA===")
    # ak historia existuje otvori nam ju

    with open(HISTOR_SUBOR,"r", encoding="utf-8") as subor:
        obsah = subor.read()
        # precita nas subor a ulozi ho do premennej obsah

        if obsah.strip():
            print(obsah)
        else:
            print("História je prázdna.")


def menu():
    vytvor_adresary()

    while True:
        print("\n=======================\n")
        print(" QR kód generátor\n")
        print("=======================\n")
        print("1. generovať QR z URL\n")
        print("2. generovať QR z textu\n")
        print("3. pozrieť históriu\n")
        print("4. ukončiť a opustiť program\n")

        vyber = input("\nVyberte jednu z možností (vo forme iba čísla možnosti napr. 1): ")
        # toto nam zabezpeci vsup od pouzivatela (v pripade nejasnosti viac na: https://www.w3schools.com/python/python_user_input.asp)

        if vyber == "1":
            url =  input("\nZadajte požadovanú adresu URL: ")
            generuj_QR(url)
        elif vyber == "2":
            text = input("\nZadajte požadovaný text: ")
            generuj_QR(text)
        elif vyber == "3":
            ukaz_historiu()
        elif vyber == "4":
            print("\nProgram ukončený.")
            exit()
        else:
            print("Neplatná voľba. Skúste znova.")

def po_prvejMoznosti_menu():
    print("\n=======================\n")
    print(" Čo chcete robiť ďalej?\n")
    print("=======================\n")
    print("1. pokračovať (späť do menu)\n")
    print("2. ukončiť program\n")

    volba = input("\nVyberte jednu z možností (vo forme samotného čísla napr. 1): ")

    if volba == "1":
        return
    elif volba == "2":
        print("\nProgram ukončený.")
        exit()
    else:
        print("Neplatná voľba. Skúste znova.")

if __name__ == "__main__":
    # pri priamom spúšťaní programu python nastavuje vstavanu premennu __name__
    # na "__main__" - chápte ako "hlavný program"
    # ak však python súbor importujete do iného skriptu/kódu/programu
    # v štýle "import moj_skript"
    # python nastaví premennú "__name__" na reálny názov daného importovaného súboru
    # pre nejasnosti viac na: https://www.reddit.com/r/learnpython/comments/14b5vww/how_does_if_name_main_work_ive_tried_to_look_at/
    menu()















