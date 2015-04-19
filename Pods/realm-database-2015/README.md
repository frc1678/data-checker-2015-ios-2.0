# realm-database-2015
Android Realm database objects for 2015.

When this gets updated on the other platform (like andriod updates files and you need to update iOS schema):

1. `git pull` the this repo.

2. Download the new realm database from Dropbox.

3. Generate new schema files.

4. Deleate the old versions of the files you just generated.

5. Add them to the folder. (like the iOS folder)

6. `git add .`,  `git commit -m "message"`, `git push` 
Do not be too concerned if the changes dont seem right, sometimes its weird about replacing files.

7. `pod update` the project that is using these (assuming that the pods are set up to automatically pull from GitHub.
