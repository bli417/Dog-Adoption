# Start

## Install
Docker Container
https://docs.docker.com/desktop/

Node.js:
https://nodejs.org/en/download/


## Start the Project
```shell
cd Phase_3
docker-compose up
```

## Login to the Adminer DBMS
- Visit http://localhost:8080/?server=db&username=team012&db=MuttHouse
- Password: cs6400
- Remeber to check "Permanent login"

## Alternative DBMS: Command-Line Tool
```shell
docker exec -it phase_3_db_1 bash
# Inside the container
root@d981f751815f:# mysql -u team012 -p MuttHouse
# Inside mysql command line tool
mysql> \c MuttHouse
mysql> # your mysql comamnd or sql statement here
mysql> \q
root@d981f751815f:/ exit
```

## Run Backend Service
```shell
docker exec -it phase_3_server_1 bash
# Only need to run this for the first time
root@3e1e6aa4a1fc:/home/node/app# npm install
root@3e1e6aa4a1fc:/home/node/app# npm run dev
[nodemon] restarting due to changes...
[nodemon] starting `node app.js`
MuttHouse listening on port 3000
```

Then make request to the server:
```
POST localhost:3000/api/v1/login
{
    "email": "team012@gatech.edu",
    "password": "team012"
}
Return
{
    "token": <x-access-token>
}
```
- check the structure.sql for user credentials. Password is the same as email without @gatech.edu part.
- use the returned \<x-access-token> for future request. For example:
```
GET localhost:3000/api/v1/user/me
Headers: x-access-token: <x-access-token>

Return
{
    "email": "team012@gatech.edu",
    "first_name": "Team",
    "last_name": "012",
    "cell_phone": "4046001111",
    "started_date": "2019-12-01T00:00:00.000Z",
    "is_admin": true
}
```

## Run Web Client
You can use docker-compose for this. But I recommend to run it directly.
```shell
cd client
# Only need to run this for the first time
npm install
npm run dev
```
Then visit http://localhost:3001

## Shut Down the Project
```shell
# shut down all containers
docker-compose down
```
This will automatically shutdown all the containers. Otherwise the containers will keep running until your manually stop them.