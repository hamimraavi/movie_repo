#!/bin/bash

# $1 - destination directory containing movies

main(){

  movielist=$(ls $1 | grep "")                   # Push movie names into variable
  
  movielist=${movielist// /.} 	      		 # Replace all spaces with dot
  movielist=${movielist//_/.}    	      	 # Replace all underscores with dot
  movielist=${movielist//-/.}    	      	 # Replace all hyphens with dot
  movielist=${movielist//:/.}         		 # Replace all colons with dot

  output="Ratings                      Movie\n"
  output="$output========================================================\n"

  for name in ${movielist}; do                   # Iterate line by line	
  
    original_name=$name
    original_name=${original_name//./ }          # Replace all dots with spaces
	
    url="http://www.omdbapi.com/?t=$name&y=&plot=short&r=xml"

    curl_result=$(curl -s $url)

    echo "$curl_result" | grep -q 'False'
    if [ $? -eq 1 ]; then                        #If movie name is listed
      rating="${curl_result#*imdbRating}"
      res=$(echo $rating | grep -m 1 "[0-9]\+\.\+[0-9]" -o)
    else                                         #If movie name is not listed
      res="N/A"
    fi	
    
    output="$output  $res   ${original_name}\n"	 
		
  done

  echo -e $output | sort -rk1
}

main "$@"

