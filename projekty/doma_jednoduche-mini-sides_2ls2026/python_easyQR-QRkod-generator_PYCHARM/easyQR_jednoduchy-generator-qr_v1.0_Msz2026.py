# MSzentpeteriova 2026
# generator QR kodu - v1.0 (zakladne telo pre generator)
# generator - pouzity na generovanie QR kodov na papierovu formu zivotopisu

# co treba najskor:
# instalovat package buď - cez windows cmd/windows powershell/git bash
#                  ako - pip install qrcode
#                alebo - pip install "qrcode[pil]" (ma aj zavislost na kniznicu pillow)
#                                                  (na generovanie obrazkov - ak by sme nemali)
#                 alebo - cez PyCharm - ikonka vľavo "python packages" - a do hladacika vpisat:
#                                                                      - qrcode
#                                                            a stiahnut najnovsiu verziu
#                                (po kliknuti na nu sa vam nad nou zobrazi popup s verziami)
#                                (a na pravej strane readme príručka s potrebnými informáciami)

import qrcode

data = input("Zadaj text alebo adresu URL: ")
# toto nam zabezpeci vsup od pouzivatela (v pripade nejasnosti viac na: https://www.w3schools.com/python/python_user_input.asp)

img = qrcode.make(data)
# toto nam qr kod vytvori
img.save("qrcode.png")
# toto nam objekt img ulozi ako subor s danou priponou do aktuálneho adresára/priečinku kde kód máme vytvorený
# ak by ste si to chceli uložiť inde, stačí pred tento súbor pridať cestu do vami zvoleného adresára
# napr. ("C:\Users\VASEKONTO\Downloads\qrcode.png")


