#!/bin/bash


#                                                *******INFORMATION IMPORTANTE********
# La première ligne du fichier paramêtres.txt doit contenir le nom du tableau.html à être créé. Car le programme a besoin de cette information avant de commencer à construire le fichier html qui contiendra les tableaux urls.
#ce programme reçoit comme parametre un fichier .txt contenant des liste d'urls. Comme résultat il crée des tableaux html contenant des liens vers les dumps et vers les sites, des informations sur le charset de fichier hmtl, ainsi que le nombre d'occurrences du terme motif et tout les tokens présents dans les dumps. 


function create_global_files() {
  
  nbdump=$1;
  langue=$2;
  x=$3;
  
  #création d'un fichier qui va contenir tous les contextes des pages aspirées
  echo "<file=$nbdump>" >> ../FICHIERGLOBAUX/CONTEXTES-GLOBAUX_$langue.txt ;
  cat ../CONTEXTES/$langue$x-utf8.txt >> ../FICHIERGLOBAUX/CONTEXTES-GLOBAUX_$langue.txt ;
    
  #création d'un fichier qui va contenir tous les dumps des pages aspirées
  echo "<file=$nbdump>" >> ../FICHIERGLOBAUX/DUMP-GLOBAUX_$langue.txt ;
  cat ../DUMP-TEXT/$langue$x-utf8.txt >> ../FICHIERGLOBAUX/DUMP-GLOBAUX_$langue.txt ;
  
  #création du fichier DUMP pour qui est utilisé pour Le Trameur
  #cŕeation du tag indicatif de fichier
  echo "<file=$nbdump>" >> ../FICHIERGLOBAUX/DUMP-GLOBAUX_LE_TRAMEUR_$langue.txt;
  #insertion du texte dump 
  sed -r "s/$motif/$motif_letrameur/g" ../DUMP-TEXT/$langue$x-utf8.txt >> ../FICHIERGLOBAUX/DUMP-GLOBAUX_LE_TRAMEUR_$langue.txt;
   
}

#la fonction create_table_line reçoit 10 arguments pour créer les lignes du tableau d'urls
function create_table_line(){
  
  #déclaration des variables pour chaque colonne du tableau
  col_index=$1;
  col_url=$2;
  col_pagaspiree=$3;
  col_retour_curl=$4;
  col_encodage=$5;
  col_dump_encodage=$6;
  col_dump_utf8=$7;
  col_contexte_utf8=$8;
  col_contexte_hmtl=$9;
  col_freq_motif=${10};
  col_index_dump=${11};
    
  #code html responsable pour la création du tableau
  echo "<tr>
  <td class=center>$col_index</td>
  <td class=center>$col_url</td>
  <td class=center>$col_pagaspiree</td>
  <td class=center>$col_retour_curl</td>
  <td class=center>$col_encodage</td>
  <td class=center>$col_dump_encodage</td>
  <td class=center>$col_dump_utf8</td>
  <td class=center>$col_contexte_utf8</td>
  <td class=center>$col_contexte_hmtl</td>
  <td class=center>$col_freq_motif</td>
  <td class=center>$col_index_dump</td>
  </tr>" >> $NOMDEFICHIER;
 }
  
function create_table () {
  
	#variable qui stock le nom du fichier .html 
  	NOMDEFICHIER=$1;

	#fichier de parametres
	fichier=$2;
	   
	
	#la variable $langue stocke l'information du fichier de langue obtenue par le code regex. Ce code capture les 4 lettres du nom du ficher concernant les infortions de langue et de pays des urls. Ex. ptBR pour portugais du Brésil, ptPT pour portugais de Portugal et etc. 
	langue=`echo $2 | grep -o [a-z][a-z][A-Z][A-Z]_`
			
	#les commandes  suivantes echo insèrent les tags pour créer le tableau qui contiendra la liste d'urls 
	echo "<table width=200 class="pretty">" >> $NOMDEFICHIER;
	
	
	#le case nous permet de choisir le bon contexte et créer le parametre-motif.txt, selon la langue utilisée
	case $langue in
		      
		frFR_)
		      motif="[Mm]ariages? [hH]omosexuels?"
		      motif2="Mariage Homosexuel"
		      motif_letrameur="MARIAGE_HOMOSEXUEL"
		      langue_pays="français | pays: France"
		      echo "MOTIF=[Mm]ariages? [hH]omosexuels?" > parametre-motif.txt		      
		      ;;
		frCA_)
		      motif="[Mm]ariages? [hH]omosexuels?"
		      motif2="Mariage Homosexuel"
		      motif_letrameur="MARIAGE_HOMOSEXUEL"
		      langue_pays="français | pays: Canada"
		      echo "MOTIF=[Mm]ariages? [hH]omosexuels?" > parametre-motif.txt		      
		      ;;		
		enUS_) 
		      motif="[Ss]ame[ -][Ss]ex [Mm]arriages?"
		      motif2="Same Sex Marriage"
		      motif_letrameur="SAME_SEX_MARRIAGE"
		      langue_pays="anglais | pays: Étas-Unis"
		      echo "MOTIF=[Ss]ame[\s-][Ss]ex [Mm]arriages?" > parametre-motif.txt
		      ;;
		enGB_) 
		      motif="[Ss]ame[ -][Ss]ex [Mm]arriages?"
		      motif2="Same Sex Marriage"
		      motif_letrameur="SAME_SEX_MARRIAGE"
		      langue_pays="anglais | pays: Angleterre"
		      echo "MOTIF=[Ss]ame[\s-][Ss]ex [Mm]arriages?" > parametre-motif.txt
		      ;;

		ptBR_) 
		      motif="[cC]asamentos? [hH]omo(s|ss)exua(l|is)"
		      motif2="Casamento Homosexual"
		      motif_letrameur="CASAMENTO_HOMOSEXUAL"
		      langue_pays="portugais | pays: Brésil"
		      echo "MOTIF=[cC]asamentos? [hH]omo(s|ss)exua(l|is)" > parametre-motif.txt
		      ;;
		      
		ptPT_) 
		      motif="[cC]asamentos? [hH]omo(s|ss)exua(l|is)"
		      motif2="Casamento Homosexual"
		      motif_letrameur="CASAMENTO_HOMOSEXUAL"
		      langue_pays="portugais | pays: Portugal"
		      echo "MOTIF=[cC]asamentos? [hH]omo(s|ss)exua(l|is)" > parametre-motif.txt
		      ;;
	esac
	
	
	echo "<thead> 
	      <th class="row1">n°</th>
	      <th class="row2">URL</th>
	      <th class="row3">Page Aspirée</th>
	      <th class="row4">Retour Curl</th>
	      <th class="row5">Encodage</th>
	      <th class="row6">Dump <br/>(non-uft8)</th>
	      <th class="row7">Dump <br/>(uft8)</th>
	      <th class="row8">Contexte</th>
	      <th class="row9">Contexte <br/>(minigrep)</th>
	      <th class="row10">Fq Motif <br/>dans DUMP</th>
	      <th class="row11">Index Dump</th>
	      </thead>
	      <tbody>"  >> $NOMDEFICHIER;
		
	#afficher message de lecture du fichier url
	echo -e 'Reading the urls file '$fichier''
	
	#création du compteur qui sera utilise dans la boucle 'for'. 
	let "x = 1";
		 
	#création du la variable qui compte les fichier dump insérés dans les fichiers de dumps globaux et contextes globaux
	nbdump=0;
		
	#Cette boucle for lit ligne à ligne le fichier avec la liste d'urls, ici refférencie par la variable $fichier
	for element in `cat ../URLS/$fichier`
	  do
	    	#commande qui aspire la page et la stocke dans le dossier /PAGE-ASPIREES. Le nom du fichier .html est construit avec l'information de variable langue (ex. enUS, ptBR...) + la numérotation construite par la variable compteur $x'
		curl -o ../PAGES-ASPIREES/$langue$x.html "$element";
	  
		#commande pour extraire l'information d'encodage du fichier!
		encodage=$(file -i ../PAGES-ASPIREES/$langue$x.html | cut -f2 -d=);
		
		#la variable $? nous permet de savoir s'il la commande curl a été bien executée. 
		retourcurl=$? ;
		
		#code en regex pour vérifier le contenu de la page aspirée. Ce code nous permet de savoir si la page a été bien aspirée
		contenupageaspiree=$(egrep -i -o "(400 )?Bad request|Moved Permanently|Not Acceptable|Access Denied|Object Moved|The document has moved" ../PAGES-ASPIREES/$langue$x.html | sort -u);
		
		#teste pour vérifier si le curl a retourné l'une des messages d'erreur specifiée par le code regex
		if [[ $contenupageaspiree != "" ]]
		then
		
			#afficher une message d'erreur dans le tableau
			retourcurl="<b>$retourcurl</b><br/>Error:$contenupageaspiree";			

		fi
		
		echo "Retour de la commande curl: $retourcurl"
		
		#vérification si la commande curl a retourné la valeur 0
		if [[ $retourcurl==0 ]] 			
		then
			
			if [[ $encodage == "utf-8" ]]
			then 
				  
				# si encodage est utf-8 on fait le traitement suivant : lynx etc
				echo "la page a $element a été bien aspirée";
				
				#aspirer le text del'url dans le dump sans les tags hmtl 
				lynx -dump -nolist -nomargins -width=1024 -display_charset="$encodage" $element > ../DUMP-TEXT/$langue$x-utf8.txt;
				  
				#extraction du contexte avec 2 lignes avant et 2 lignes après le motif			  
				egrep -i "$motif" -A2 -B2 ../DUMP-TEXT/$langue$x-utf8.txt > ../CONTEXTES/$langue$x-utf8.txt 
			  	
			  	#création du fichier index-dump
			  	egrep -o "\w+" ../DUMP-TEXT/$langue$x-utf8.txt | sort | uniq -c | sort -r > ../DUMP-TEXT/index-$langue$x.txt ;
						  	
				#execution du script minigrep pour construire le fichier .html avec le contexte mise en évidence 
				perl ../PROGRAMMES/minigrep/minigrepmultilingue.pl "utf-8" ../DUMP-TEXT/$langue$x-utf8.txt parametre-motif.txt --fileout="../CONTEXTES/$langue$x-utf8.html";
								  
				#comptage d'ocurrences du motif dans la page aspirée
				comptagemotif=$(egrep -io "$motif" ../DUMP-TEXT/$langue$x-utf8.txt | wc -l);
				  
				echo "======> $element =====> traitement 1"
						  
				create_table_line $x "<a href=\"$element\">$element</a>" "<a href=\"../PAGES-ASPIREES/$langue$x.html\">$x</a>" "$retourcurl" "$encodage<br/>(detect-encodage)" "-" "<a href=\"../DUMP-TEXT/$langue$x-utf8.txt\">dump-$x</a>" "<a href=\"../CONTEXTES/$langue$x-utf8.txt\">contexte-$x</a>" "<a href=\"../CONTEXTES/$langue$x-utf8.html\">contexte-$x</a>" $comptagemotif "<a href=\"../DUMP-TEXT/index-$langue$x.txt\">index-$x</a>"
				
				create_global_files $nbdump $langue $x;
				  				    
				#incrémenatation du compteur de la variable 
				let "nbdump+=1";
				
				#incrémenatation du compteur index
				let "x = x + 1";			  
			else 
			  
				#l'encodage n'est pas utf-8. Utilisation de l'iconv pour vérifier l'encodage de la page aspirée. 
				encodage_iconv=$(iconv -l | egrep -io $encodage | sort -u);
					if [[ $encodage_iconv == "" ]]
					then
							# afficher message d'erreur
							echo "L'encogade n'a pas été trouvée. Chercher le 'charsert'";
							
							if egrep -qi "meta.+charset" ../PAGES-ASPIREES/$langue$x.html ; 
								then
									# afficher message de charsert trouvé
									echo "Charset détecté! Récupération de charset en cours";
									
									#regex pour récupérer un des informations de regex sur la page et la stocker dans la variable encodage
									encodage=$(egrep -m 1 -o '(((utf|UTF)-(8|16|32))|(gb|GB)(k|K|2312|18030)|(iso|ISO|Iso)-8859-(\w)(\w)?|(WINDOWS|windows)-1252|(WINDOWS|windows)-1256|((m|M)(a|A)(c|C)(R|r)(O|o)(M|m)(a|A)(n|N))|us-ascii)' ../PAGES-ASPIREES/$langue$x.html | tr "a-z" "A-Z" | sort -u) ;
									
									#afficher le charset trouvé
									echo "charset extrait : $encodage ";
																		
									#vérification du charset
									encodage_iconv=$(iconv -l | egrep -io $encodage | sort -u);
									if [[ $encodage_iconv == "" ]]
										then
											#cette encodage ne peut pas être traitée par iconv
											echo "encodage non connu de iconv... on fait rien...";
											
											echo "======> $element =====> traitement 2"
																						
											#insérer ligne aux tableau d'urls
											create_table_line $x "<a href=\"$element\">$element</a>" "<a href=\"../PAGES-ASPIREES/$langue$x.html\">$x</a>" "$retourcurl" "charset<br/>encodage<br/>non reconnus" "-" "-" "&nbsp;-&nbsp;" "&nbsp;-&nbsp;" "&nbsp;-&nbsp;" "&nbsp;-&nbsp;"
											
											let "x = x + 1";													
										else 											
											echo "Le charset peut être traité par iconv.";
											echo "Traitement en cours...";
											lynx -dump -nolist -nomargins -width=1024 -display_charset="$encodage" $element  > ../DUMP-TEXT/$langue$x.txt ;
											iconv -f $encodage -t utf-8 ../DUMP-TEXT/index-$langue$x.txt > ../DUMP-TEXT/$langue$x-utf8.txt ;
											egrep -i "$motif" ../DUMP-TEXT/$langue$x-utf8.txt > ../CONTEXTES/$langue$x-utf8.txt ;
											perl ../PROGRAMMES/minigrep/minigrepmultilingue.pl "utf-8" ../DUMP-TEXT/$langue$x-utf8.txt parametre-motif.txt --fileout="../CONTEXTES/$langue$x-utf8.html" ;
											
											comptagemotif=$(egrep -io "$motif" ../DUMP-TEXT/$langue$x-utf8.txt | wc -l);
																			
											#contexte crée par Minigrep 
											egrep -o "\w+" ../DUMP-TEXT/$langue$x-utf8.txt | sort | uniq -c | sort -r > ../DUMP-TEXT/index-$langue$x.txt ;
											
											echo "======> $element =====> traitement 3"
																						
											#insérer ligne au tableau d'urls
											create_table_line $x "<a href=\"$element\">$element</a>" "<a href=\"../PAGES-ASPIREES/$langue$x.html\">$x</a>" "$retourcurl" "$encodage<br/>(charset extrait)" "<a href=\"../DUMP-TEXT/$langue$x.txt\">dump-$x</a>" "<a href=\"../DUMP-TEXT/$langue$x-utf8.txt\">dump-$x</a>" "<a href=\"../CONTEXTES/$langue$x-utf8.txt\">contexte-$x</a>" "<a href=\"../CONTEXTES/$langue$x-utf8.html\">contexte-$x</a>" $comptagemotif "<a href=\"../DUMP-TEXT/index-$langue$x.txt\">index-$x</a>"
																						
											create_global_files "$nbdump" "$langue" "$x";
											let "nbdump+=1";
											let "x = x + 1";
									fi
							else
								# afficher message de charset pas trouvé
								echo "le charset n'a pas été trouvé. Aucun traitement sera fait";
													
								echo "======> $element =====> traitement 4"
							      
								blank="&nbsp;-&nbsp;"
																
								create_table_line $x "<a href=\"$element\">$element</a>" "<a href=\"../PAGES-ASPIREES/$langue$x.html\">$x</a>" "$retourcurl" "pas de charset..." "-" "-" $blank $blank $blank $blank
																		
								let "x = x + 1";
							fi
					else
							# afficher message d'encodage connu
							echo "L'encogade est connu de iconv";
											
							#aspirer page
							lynx -dump -nolist -nomargins -width=1024 -display_charset="$encodage" $element  > ../DUMP-TEXT/$langue$x.txt ;
							iconv -f $encodage -t utf-8 ../DUMP-TEXT/$langue$x.txt > ../DUMP-TEXT/$langue$x-utf8.txt
							egrep -i "$motif" ../DUMP-TEXT/$langue$x-utf8.txt > ../CONTEXTES/$langue$x-utf8.txt ;
							perl ../PROGRAMMES/minigrep/minigrepmultilingue.pl "utf-8" ../DUMP-TEXT/$langue$x-utf8.txt parametre-motif.txt --fileout="../CONTEXTES/$langue$x-utf8.html";
							comptagemotif=$(egrep -io "$motif" ../DUMP-TEXT/$langue$x-utf8.txt | wc -l);
							egrep -o "\w+" ../DUMP-TEXT/$langue$x-utf8.txt | sort | uniq -c | sort -r > ../DUMP-TEXT/index-$langue$x.txt ;
							
							echo "======> $element =====> traitement 5"
							
							#insérer ligne avec la fonction create_table_line
							create_table_line $x "<a href=\"$element\">$element</a>" "<a href=\"../PAGES-ASPIREES/$langue$x.html\">$x</a>" "$retourcurl" "$encodage<br/>(detect-encodage ; iconv OK)" "<a href=\"../DUMP-TEXT/$langue$x.txt\">dump-$x</a>" "<a href=\"../DUMP-TEXT/$langue$x-utf8.txt\">dump-$x</a>" "<a href=\"../CONTEXTES/$langue$x-utf8.txt\">contexte-$x</a>" "<a href=\"../CONTEXTES/$langue$x-utf8.html\">contexte-$x</a>" $comptagemotif "<a href=\"../DUMP-TEXT/index-$langue$x.txt\">index-$x</a></td>"
							
							#créer les dumps avec la fonction create_global_file
							create_global_file "$nbdump" "$langue" "$x";
							let "nbdump+=1";
							let "x = x + 1";							
					fi				
			 fi	
		else
			echo "Problème lors de l'aspiration de la page. Aucun traitement sera effectué.";
		
			echo "======> $element =====> traitement 6"
						
			#insérer ligne avec la fonction create_table_line			
			create_table_line $x "<a href=\"$element\">$element</a>" $blank "$retourcurl" $blank $blank $blank $blank $blank $blank $blank
			
			let "x = x + 1";
			
		fi			
	done	
		
	egrep -o "\w+" ../FICHIERGLOBAUX/DUMP-GLOBAUX_$langue.txt | sort | uniq -c | sort -r > ../FICHIERGLOBAUX/index-dump-$langue.txt ;
	egrep -o "\w+" ../FICHIERGLOBAUX/CONTEXTES-GLOBAUX_$langue.txt | sort | uniq -c | sort -r > ../FICHIERGLOBAUX/index-contexte-$langue.txt ;
	echo "<tr><td class="center" colspan=\"6\" bgcolor=\"silver\">&nbsp</td><td class="center" width=\"100\"><a href="../FICHIERGLOBAUX/DUMP-GLOBAUX_$langue.txt"><b>Fichier Dump<br/>global</a><br/></b><small>$nbdump fichier(s)</small></td><td class="center" width=\"100\"><a href="../FICHIERGLOBAUX/CONTEXTES-GLOBAUX_$langue.txt"><b>Fichier Contexte<br/>global</a><br/></b><small>$nbdump fichier(s)</small></td><td colspan="3" bgcolor=\"silver\"></td></tr>" >> $NOMDEFICHIER;
			
	echo "<tr><td class="center" colspan=\"6\" bgcolor=\"silver\">&nbsp</td><td class="center" width=\"100\"><a href="../FICHIERGLOBAUX/index-dump-$langue.txt"><b>Index Dump<br/>global</b></a><br/><small>$nbdump fichier(s)</small></td><td class="center" width=\"100\"><a href="../FICHIERGLOBAUX/index-contexte-$langue.txt"><b>Index Contextes<br/>global</a><br/></b><small>$nbdump fichier(s)</small></td><td colspan="3" bgcolor=\"silver\"></td></tr>" >> $NOMDEFICHIER;
	let "x = x + 1";
				
echo "</tbody>
      </table>" >> $NOMDEFICHIER;
echo "<p><hr/></p>" >> $NOMDEFICHIER;

}

#boucle for pour lire le fichier parametres.txt, ici representé dans la variable $1
for line in $(cat $1); do

		#teste conditionnel pour vérifier quelles lignes du fichier parametres.txt commencent par schéma "../TABLEAUX/"
		if ( echo $line | grep -qs TABLEAUX ); then

			#la variable nomfichier permet de garder le nom du fichier html, lorque la boucle for lit la deuxième ligne du fichier 			paramêtres.txt Le nom du fichier html doit être enregistré parce qu'il sera utilisé pour finaliser le fichier html à la fin du 			programme, après la création des tableaux urls'
			NOMFICHIER=$line
			
			echo -e '****** creating '$NOMFICHIER' ******'
			#création du fichier html
cat > $NOMFICHIER <<EOF
<html>
  <head>
    <title>URL List </title>
    <meta charset="UTF-8"/>
  </head>
  <body>
    <style>
 .center { text-align: center; }
      .container { width: 1024px; margin: 0 auto; }
      table.pretty { margin: 0px auto; border: 1px solid #970c65; margin: 0; padding: 0; table-layout: fixed; width:100%; }
      table.pretty td { border: 1px solid #970c65; padding: 5px; word-break: break-word;}
      table.pretty tr:nth-child(even) { background: #f7ecf5 }
      
      a { text-decoration: none; color: #000; }
      a:hover { text-decoration: underline; }
      .row1 {width:5%}
      .row2 {width:40%}
      .row3 {width:7%}
      .row4 {width:12%}
      .row5 {width:12%}
      .row6 {width:12%}
      .row7 {width:12%}
      .row8 {width:12%}
      .row9 {width:12%}
      .row10 {width:12%}
      .row11 {width:12%}
    </style>
    <div class="container">
      <h1 class="center"> URLS </h1>
EOF
		else
			if ( echo $line | egrep -qs URLS ); then

				#afficher message de création des tableaux urls
				echo -e '****** preparing to read the '$line' file ******'
				
				#creation du tableau
				for fichier in `ls $line`
					do
					  #créer les tableaux	
					  create_table $NOMFICHIER $fichier
				done

			#fin du teste if
			fi
		fi	

#fin de la boucle for de lecture du fichier paramêtres.txt
done < $1

#afficher un message pour indiquer la finalisation du procès 
echo -e '****** finalizing the html file ******'

cat >>$NOMFICHIER <<EOF
    </div>
  </body>
</html>
EOF

#afficher un message pour indiquer la finalisation du procès 
echo -e '****** DONE! ******'

