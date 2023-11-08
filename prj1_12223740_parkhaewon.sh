#!/bin/bash
echo "--------------------------"
echo "User Name: parkhaewon"
echo "student Number: 12223740"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.data'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' int 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"
while true; do
read -p "Enter your choice [1-9]: " choice
case $choice in
1)
read -p "please enter the 'movie id' (1~1682): " movie_id
awk -F '|' -v movie_id="$movie_id" '$1 == movie_id {print $0}' u.item
;;
2)
read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n): " choice
if [ $choice == "y" ]; then
awk -F '|' '$7==1 {print $1, $2}' u.item |sort -n | head
fi
;;
3)
read -p "Please enter the 'movie id' (1~1682): " movie_id
ratings=$(awk -v movie_id="$movie_id" '$2 == movie_id {sum += $3; count++} END {if(count>0)printf("%.5f\n", sum/ count)}' u.data)
echo "Average rating of 'movie id' $movie_id: $ratings"
;;
4)
read -p "Do you want to delete the 'IMDB URL' from 'u.item'? (y/n): " choice
if [ $choice == "y" ]; then
	sed 's/http[^)]*)//' u.item | head -n 10
fi
;;
5)
read -p "Do you want to get the data about users from 'u.user'?(y/n): " choice
if [ $choice == "y" ]; then
	sed 's/|/ /g; s/M/ male/; s/F/ female/; s/^\([0-9]*\) \([0-9]*\) \([a-z]*\) \([^|]*\) \([0-9]*\)/user \1 is \2 years old \3 \4/' u.user| head -n 10
fi
;;
6)
read -p "Do you want to modify the format of 'release date' in 'u.item'? (y/n): " choice
if [ $choice == "y" ]; then
	sed 's/|\(..\)-Jan-\([0-9]*\)|/|\201\1|/;s/|\(..\)-Feb-\([0-9]*\)|/|\202\1|/;s/|\(..\)-Mar-\([0-9]*\)|/|\203\1|/;s/|\(..\)-Apr-\([0-9]*\)|/|\204\1|/;s/|\(..\)-May-\([0-9]*\)|/|\205\1|/;s/|\(..\)-Jun-\([0-9]*\)|/|\206\1|/;s/|\(..\)-Jul-\([0-9]*\)|/|\207\1|/;s/|\(..\)-Aug-\([0-9]*\)|/|\208\1|/;s/|\(..\)-Sep-\([0-9]*\)|/|\209\1|/;s/|\(..\)-Oct-\([0-9]*\)|/|\210\1|/;s/|\(..\)-Nov-\([0-9]*\)|/|\211\1|/;s/|\(..\)-Dec-\([0-9]*\)|/|\212\1|/' u.item | tail -n 10
fi
;;
7)
read -p "Please enter the 'user id' (1~943): " user_id
awk -F '\t' -v user_id="$user_id" ' $1 == user_id {print $2}' u.data | sort -n | xargs -I {} awk -F '|' '$1 == {} {print $1}' u.item | tr '\n' '|'
awk -F '\t' -v user_id="$user_id" '$1 == user_id {print $2}' u.data | sort -n | head -10 | xargs -I {} awk -F '|' '$1 == {} {print $1"|"$2}' u.item
;;
8)
read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n): " choice
if [ $choice == "y" ]; then
	awk -F '\t' -v FS='\t' -v OFS=' ' -v user_id=24 '$1>=20 && $1 <=29 && $4 == "programmer" { user_ids[$2] =1; movie_ratings[$2] += $3; movie_counts[$2]++;}
	END{for(movie_id in user_ids){ if(movie_counts[movie_id] >0){ average_rating = movie_ratings[movie_id] / movie_counts[movie_id]; printf("%d %.5f\n", movie_id, average_rating);}}}' u.user u.data | sort -n
fi
;;
9)
echo "Bye!"
exit
;;
esac
done
