<b>Postman</b>
<br> je navrzen jako npm projekt, ve kterem je definovan npm run script pro spusteni cele test suite (Newman CLI)
<i>pozn. potreba domyslet oauth2 autorizaci tak, aby bylo mozne pouzit access_token jako promennou kolekce</i>
```
cd ./postman
npm run test
```

<b>RobotFramework</b>
<br>
```
cd ./robotframework
robot --loglevel trace --outputdir ./out ./suites/T3_prihlaseni_uzivatele.robot ./suites/T12_kosik_pridani_produktu.robot
```