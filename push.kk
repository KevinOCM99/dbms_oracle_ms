if [ $(hostname) = 'myjump' ]
then
git add .
git commit -am "$(date +"%D %T")"
git push
else
echo "Please do it from Jump Server"
fi
