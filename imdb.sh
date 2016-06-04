#!/bin/bash

# $1 - destination directory containing movies

function preprocess_temps(){
  
  touch /tmp/movielist.txt
  touch /tmp/output.txt
  ls $1 > /tmp/movielist.txt
}

function print_results(){
  echo "Ratings                      Movie"
  echo "========================================================"
  sort -k 1 -r /tmp/output.txt
}

main(){

  preprocess_temps $1

  for ((i=1;; i++)); do
	
  read name || break;
  
    original_name=$name

    name=${name// /.} 				 # Replace all spaces with dot
    name=${name//_/.} 				 # Replace all underscores with dot
    name=${name//-/.} 				 # Replace all hyphens with dot
    name=${name//:/.} 				 # Replace all colons with dot
	
    url="http://www.omdbapi.com/?t=$name&y=&plot=short&r=xml"

    curl_result=$(curl -s $url)

    rating="${curl_result#*imdbRating}"
    
    if [[ $rating == =* ]]; then
      res=$(echo $rating | grep -m 1 "[0-9]\+\.\+[0-9]" -o)
    else
      res=N/A
    fi	
	
    echo "  ${res}   ${original_name}" >> /tmp/output.txt	 
		
  done < /tmp/movielist.txt

  print_results

  rm /tmp/movielist.txt
  rm /tmp/output.txt
}

main "$@"

