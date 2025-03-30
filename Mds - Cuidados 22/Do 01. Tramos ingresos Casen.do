clear all
use "C:\CMP\2022\2022 05 19 Revisión Casen y EBS\data\Casen en Pandemia 2020 STATA.dta", replace
* Eliminación de 98 observaciones nucleo == 0
drop if nucleo == 0

* Generación de deciles a partir de [yae]
xtile dyae = yae [fw = expr], nq(10)

* Creación de grupos socioeconómicos.
gen grupos = 0
replace grupos = 1 if yae < lp
replace grupos = 2 if yae >= lp & yae < 1.5*lp
replace grupos = 5 if dyae == 10

* Creación base auxiliar con RVA y RVB para aquellos con grupo == 0
preserve
keep if grupos == 0
keep folio yae expr
xtile auxdec = yae [fw = expr], nq(2)
keep folio auxdec
* Se almacena la información a nivel de hogar
duplicates drop folio, force
save "C:\CMP\2022\2022 05 19 Revisión Casen y EBS\data\aux_rvarvb.dta", replace
* Merge de base original con auxiliar
restore
* Merge a través del folio hogar
merge m:1 folio using "C:\CMP\2022\2022 05 19 Revisión Casen y EBS\data\aux_rvarvb.dta"

replace grupos = 3 if auxdec == 1
replace grupos = 4 if auxdec == 2

lab define lblgrupos 1 "Pobres" 2 "Vulnerables" 3 "Riesgo vulnerabilidad alto" 4 "Riesgo vulnerabilidad bajo" 5 "Altos Ingresos"
lab value grupos lblgrupos

tab grupos [fw=expr] if grupos != 0

lab drop lblgrupos
lab define lblgrupos 1 "Pobres" 2 "Vulnerables" 3 "Riesgo vulnerabilidad alto" 4 "Riesgo vulnerabilidad bajo" 5 "Altos Ingresos"
lab value grupos lblgrupos

gen nna=0
replace nna=1 if edad<18

gen am=0
replace am=1 if edad>59

bys folio: egen n_nna=total(nna)
bys folio: egen n_am=total(am)

*GRUPOS
gen hogar_depen = .
* 1. Con NNA.
replace hogar_depen = 1 if n_nna > 0 & n_am == 0
* 2. Con AM.
replace hogar_depen = 2 if n_nna == 0 & n_am > 0
* 3. Con ambos.
replace hogar_depen = 3 if n_nna > 0 & n_am > 0
* 4. Con ninguno.
replace hogar_depen = 4 if n_nna == 0 & n_am == 0

* Se almacena la información de folio y grupo socioeconómico para complementar la base EBS
duplicates drop folio, force
keep folio grupos hogar_depen ypchtotcor
save "C:\CMP\2022\2022 05 19 Revisión Casen y EBS\data\aux_grupos_casen.dta", replace
