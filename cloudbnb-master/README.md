This is the readme file.

Instructions:

signing onto postgres:
psql airbnbclone_dev dan

listing all the tables:
\d




Git will cache your password 
git config --global credential.helper 'cache --timeout=3600'


-Create branch:
git checkout -b <branchname>
-make changes
-git add . -A
-git status

git commit -m (commmemts)
git checkout master
git merge <branchname>

to pull all the new changes::::::
git reset --hard HEAD
git pull



to push all changes to github::::
git push origin master



adding a column in a table for schema or such things:
rails generate migration add_knack_to_spaces kanck:string