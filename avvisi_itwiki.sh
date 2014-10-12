#!/bin/bash

date=$(date +"%Y%m%d")
cat_file="data/categorizzare/"$date".txt"
cat_tl_file="data/categorizzare_template/"$date".txt"
vsu_file="data/voci_senza_uscita/"$date".txt"
vo_file="data/voci_orfane/"$date".txt"

echo "-----------------------"
echo "["$(date +%Y%m%d%H%M%S)"] Starting!"

#####

echo "["$(date +%Y%m%d%H%M%S)"] Generating list for categorizzare..."

start=$(date +%s.%N)

categorizzare=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "SELECT CONCAT(\"# [[\", page_title, \"]]\") FROM page WHERE page_namespace = 0 AND page_is_redirect = 0 AND page_id NOT IN (SELECT page_id FROM page WHERE page_id IN ( SELECT cl_from FROM categorylinks WHERE cl_to NOT IN ( SELECT page_title FROM categorylinks, page WHERE cl_to = 'Categorie_nascoste' AND page_id = cl_from)) AND page_namespace = 0 AND page_is_redirect = 0) AND page_id NOT IN (SELECT page_id FROM page JOIN templatelinks ON page_id = tl_from WHERE tl_namespace = 10 AND tl_title = 'Categorizzare') AND page_id NOT IN (SELECT pr_page FROM page_restrictions) ORDER BY page_title" itwiki_p)

end=$(date +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list for categorizzare..."
echo $categorizzare > $cat_file

# tail -n +2 $cat_file

echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for categorizzare"
python /data/project/alessiobot/script/add_categorizzare.py >> /data/project/alessiobot/log/add_categorizzare.txt 2>&1 &

#####

echo "["$(date +%Y%m%d%H%M%S)"] Generating list for categorizzare template..."

start=$(date +%s.%N)

categorizzare_template=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "SELECT CONCAT(\"# [[Template:\", page_title, \"]]\") FROM page WHERE page_namespace = 10 AND page_title NOT LIKE '%/%' AND page_is_redirect = 0 AND page_id NOT IN (SELECT page_id FROM page WHERE page_id IN ( SELECT cl_from FROM categorylinks WHERE cl_to NOT IN ( SELECT page_title FROM categorylinks, page WHERE cl_to = 'Categorie_nascoste' AND page_id = cl_from)) AND page_namespace = 10 AND page_is_redirect = 0) AND page_id NOT IN (SELECT tl_from FROM templatelinks WHERE tl_title = 'Categorizzare') ORDER BY page_title" itwiki_p)

end=$(date +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list for categorizzare template..."
echo $categorizzare_template > $cat_tl_file

# tail -n +2 $cat_file

echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for categorizzare template"
#python /data/project/alessiobot/script/add_cat_to_tl.py >> /data/project/alessiobot/log/add_cat_to_tl.txt 2>&1 &

#####

echo "["$(date +%Y%m%d%H%M%S)"] Generating list for voci senza uscita..."

start=$(date +%s.%N)

voci_senza_uscita=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "SELECT CONCAT('# [[', page_title, ']]') FROM page WHERE page_namespace = 0 AND page_is_redirect = 0 AND page_id NOT IN (SELECT pl_from FROM pagelinks WHERE pl_namespace = 0 AND pl_title IN (SELECT page_title FROM page WHERE page_namespace = 0) AND pl_title NOT IN (SELECT page_title FROM categorylinks, pagelinks, page WHERE cl_to = pl_title AND cl_from = page_id AND pl_namespace = 14 AND pl_from = 4195411)) /* Wikipedia:ConnectivityProjectInternationalization/ArticlesNotFormingValidLinks */ AND page_id NOT IN (SELECT pp_page FROM page_props WHERE pp_propname = 'disambiguation') AND page_id NOT IN (SELECT page_id FROM page JOIN templatelinks ON page_id = tl_from WHERE tl_namespace = 10 AND tl_title = 'Voci_senza_uscita') AND page_id NOT IN (SELECT pr_page FROM page_restrictions) ORDER BY page_title" itwiki_p)

end=$(date +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list for voci senza uscita..."
echo $voci_senza_uscita > $vsu_file

# tail -n +2 $cat_file

echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for voci senza uscita"
python /data/project/alessiobot/script/add_dead_end.py >> /data/project/alessiobot/log/add_dead_end.txt 2>&1 &

######

echo "["$(date +%Y%m%d%H%M%S)"] Generating list for voci orfane..."

start=$(date +%s.%N)

voci_orfane=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "SELECT CONCAT('# [[', page_title, ']]') FROM page WHERE page_namespace = 0 AND page_is_redirect = 0 AND page_title NOT IN (SELECT pl_title FROM pagelinks WHERE pl_namespace = 0 AND pl_from NOT IN (SELECT page_id FROM page WHERE page_namespace <> 0) AND pl_from NOT IN (SELECT cl_from FROM categorylinks, pagelinks WHERE cl_to = pl_title AND pl_namespace = 14 AND pl_from = 4195411)) AND page_id NOT IN (SELECT pp_page FROM page_props WHERE pp_propname = 'disambiguation') AND page_id NOT IN (SELECT cl_from FROM categorylinks, pagelinks WHERE cl_to = pl_title AND pl_namespace = 14 AND pl_from = 4195411) AND page_id NOT IN (SELECT page_id FROM page JOIN templatelinks ON page_id = tl_from WHERE tl_namespace = 10 AND tl_title = 'O') AND page_id NOT IN (SELECT pr_page FROM page_restrictions) ORDER BY page_title" itwiki_p)

end=$(date +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list for voci orfane..."
echo $voci_orfane > $vo_file

# tail -n +2 $cat_file

echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for voci orfane"
python /data/project/alessiobot/script/add_orfana.py >> /data/project/alessiobot/log/add_orfana.txt 2>&1

#####

echo "["$(date +%Y%m%d%H%M%S)"] Ending!"
