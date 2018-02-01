if [ $(hostname) = 'myjump' ]
then
git add .
git commit -m "$(date +"%D %T")"
git push
fi
