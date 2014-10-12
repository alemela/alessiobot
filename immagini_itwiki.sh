#!/bin/bash

date=$(date +"%Y%m%d")
pd_italia_file="data/immagini/immagini_PD-italia/"$date".txt"
libere_file="data/immagini/immagini_libere/"$date".txt"
non_libere_file="data/immagini/immagini_non_libere/"$date".txt"
sconosciute_file="data/immagini/immagini_sconosciute/"$date".txt"

echo "-----------------------"
echo "["$(date +%Y%m%d%H%M%S)"] Starting!"

#####

echo "["$(date +%Y%m%d%H%M%S)"] Generating list for immagini PD-italia..."

start=$(date +%s.%N)

pd_italia=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "SELECT CONCAT(\"# [[File:\", page_title, \"]]\") FROM page WHERE page_namespace = 6 AND page_is_redirect = 0 AND page_title NOT IN (SELECT il_to FROM imagelinks) AND page_title IN (SELECT img_name FROM image) AND page_id NOT IN (SELECT tl_from FROM templatelinks WHERE tl_title = 'Immagine_orfana') AND page_id IN  (SELECT cl_from FROM categorylinks WHERE cl_to = 'PD_Italia' OR cl_to = 'Screenshot_film_PD-Italia') ORDER BY page_title" itwiki_p)

end=$(date +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list for immagini PD-italia..."
echo $pd_italia > $pd_italia_file

echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for immagini PD-italia"
python /data/project/alessiobot/script/add_immagine_orfana.py PD_italia >> /data/project/alessiobot/log/immagini/add_orfana_pd-italia.txt 2>&1 &

#####

echo "["$(date +%Y%m%d%H%M%S)"] Generating list for immagini libere..."

start=$(date +%s.%N)

libere=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "SELECT CONCAT('# [[File:', page_title, ']]') FROM page WHERE page_namespace = 6 AND page_is_redirect = 0 AND page_title NOT IN (SELECT il_to FROM imagelinks) AND page_id NOT IN (SELECT tl_from FROM templatelinks WHERE tl_title = 'Immagine_orfana') AND page_title IN (SELECT img_name FROM image) AND page_id IN  (SELECT cl_from FROM categorylinks, page WHERE cl_to = 'Immagini BSD' OR cl_to = 'Immagini_Creative_Commons_libere' OR cl_to = 'Immagini_Creative_Commons_by_1.0' OR cl_to LIKE 'Immagini_Creative_Commons_by_2%' OR cl_to = 'Immagini_Creative_Commons_by_3.0' OR cl_to = 'Immagini_Creative_Commons_by_4.0' OR cl_to LIKE 'Immagini_Creative_Commons_by-sa%' OR cl_to = 'Immagini_Creative_Commons_sa_1.0' OR cl_to = 'Immagini_Creative_Commons_Zero' OR cl_to = 'FAL' OR cl_to LIKE 'Immagini_GFDL%' OR cl_to = 'Immagini_GPL' OR cl_to = 'LGPL' OR cl_to = 'Immagini_MIT' OR cl_to = 'Immagini_protette_uso_libero' OR cl_to = 'Immagini_protette_con_condizioni' OR cl_to = 'Immagini_protette_uso_libero_con_attribuzione' OR cl_to = 'Immagini_di_paesi_non_firmatari_della_convenzione_di_Berna' OR cl_to = 'PD_altri_motivi' OR cl_to = 'PD_Arte' OR cl_to = 'PD_Autore' OR cl_to = 'PD_BritishGov' OR cl_to = 'PD_NASA' OR cl_to = 'PD_Old' OR cl_to = 'PD_Polonia' OR cl_to = 'PD_Russia' OR cl_to = 'PD_USA' OR cl_to = 'PD_Utente' OR cl_to = 'PD-USGov' OR cl_to = 'Screenshot_film_PD-Giappone' OR cl_to = 'PD_Argentina' OR cl_to = 'PD-Requisiti' OR cl_to = 'PD-SerbiaGov') ORDER BY page_title" itwiki_p)

end=$(date +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list for immagini libere..."
echo $libere > $libere_file

echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for immagini libere"
python /data/project/alessiobot/script/add_immmagine_orfana.py libere >> /data/project/alessiobot/log/immagini/add_orfana_libera.txt 2>&1 &

#####

echo "["$(date +%Y%m%d%H%M%S)"] Generating list for immagini non libere..."

start=$(date +%s.%N)

non_libere=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "SELECT CONCAT('# [[:File:', page_title, ']]') FROM page WHERE page_namespace = 6 AND page_is_redirect = 0 AND page_title NOT IN (SELECT il_to FROM imagelinks) AND page_id NOT IN (SELECT tl_from FROM templatelinks WHERE tl_title = 'Immagine_orfana') AND page_title IN (SELECT img_name FROM image) AND page_id IN  (SELECT cl_from FROM categorylinks, page WHERE cl_to LIKE 'Immagini_Creative_Commons_nc%' OR cl_to LIKE 'Immagini_Creative_Commons_nd%' OR cl_to LIKE 'Immagini_Creative_Commons_by-nc%' OR cl_to LIKE 'Immagini_Creative_Commons_by-nd%' OR cl_to = 'Autorizzate_per_Wikipedia' OR cl_to LIKE 'Copertine_d%' OR cl_to LIKE 'Copyright%' OR cl_to = 'Immagini_di_Donkey_Kong' OR cl_to = 'Immagini_di_Mario' OR cl_to = 'Immagini_di_Wario' OR cl_to = 'Immagini_di_Yoshi' OR cl_to = 'Immagini_logo_partiti_autorizzati' OR cl_to = 'Immagini_stemmi_autorizzati' OR cl_to = 'Immagini_stemmi_ecclesiastici' OR cl_to = 'Immagini_fairuse-bandiere' OR cl_to = 'Immagini_fairuse-francobolli' OR cl_to = 'Immagini_fairuse-monete' OR cl_to = 'Immagini_di_euro' OR cl_to = 'Immagini_fairuse-stemmi' OR cl_to = 'Immagini_stemmi_nazionali' OR cl_to = 'Marchi_registrati' OR cl_to = 'Immagini_con_marchi_registrati' OR cl_to = 'Marchi_senza_fonte' OR cl_to = 'Immagini_non_commerciali' OR cl_to LIKE 'Crown_Copyright%' OR cl_to = 'Immagini_ESA' OR cl_to = 'Immagini_NATO' OR cl_to = 'PoloniaGov' OR cl_to = 'Immagini_dal_sito_del_Parlamento_Europeo' OR cl_to LIKE 'Screenshot_Microsoft%' OR cl_to = 'Screenshot_videogiochi_Microsoft' OR cl_to = 'Immagini_di_Due_fantagenitori' OR cl_to LIKE 'Screenshot_d%' OR cl_to LIKE 'Screenshot_Copyright%' OR cl_to LIKE 'Opere_protette_da%') ORDER BY page_title" itwiki_p)

end=$(date +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list for immagini non libere..."
echo $non_libere > $non_libere_file

echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for immagini non libere"
python /data/project/alessiobot/script/add_immagine_orfana.py non_libere >> /data/project/alessiobot/log/immagini/add_orfana_non_libera.txt 2>&1

#####

echo "["$(date +%Y%m%d%H%M%S)"] Generating list for immagini sconosciute..."

start=$(date +%s.%N)

sconosciute=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "SELECT CONCAT('# [[:File:', page_title, ']]') FROM page WHERE page_namespace = 6 AND page_is_redirect = 0 AND page_title NOT IN (SELECT il_to FROM imagelinks) AND page_title IN (SELECT img_name FROM image) AND page_id NOT IN (SELECT tl_from FROM templatelinks WHERE tl_title = 'Immagine_orfana') AND page_id NOT IN (SELECT cl_from FROM categorylinks WHERE cl_to LIKE 'Immagini_senza_informazioni%' OR cl_to = 'Immagini_di_servizio_da_non_cancellare') ORDER BY page_title" itwiki_p)
end=$(date +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list for immagini sconosciute..."
echo $sconosciute > $sconosciute_file

echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for immagini sconosciute"
python /data/project/alessiobot/script/add_immagine_orfana.py sconosciute >> /data/project/alessiobot/log/immagini/add_orfana_sconosciuta.txt 2>&1 &

#####
