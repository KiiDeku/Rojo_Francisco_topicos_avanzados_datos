"# topicos avanzados " 
Paso a Paso para preparar entorno.
Levante el contenedor mediante: 
docker-compose up --build

Una vez que el contenedor se ejecute correctamente, en otra consola copie el script sobre el contenedor: docker cp _______.sql oracle_db_course:/tmp/_____.sql
Ingrese al contenedor: docker-compose exec oracle-db bash

Conectese a la base de datos: sqlplus curso_topicos/curso2025@//localhost:1521/XEPDB1
Ejecute el script que copiamos en el contenedor en el paso 1: @/tmp/__________.sql


⠀⠀⠀⠀⢨⠊⠀⢀⢀⠀⠀⠀⠈⠺⡵⡱⠀⠀⠀⢠⠃⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⢰⡁⠉⠊⠙⢎⣆⠀⠀⠀⠀⢩⢀⠜⠀⠀⠀
⠀⠀⠀⢠⠃⠀⠀⢸⢸⡀⠀⠀⠀⠀⠘⢷⡡⠀⠀⠎⠀⢰⣧⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠈⣐⢤⣀⣀⢙⠦⠀⠀⠀⠀⡇⠀⠀⠀⠀
⠀⠀⢀⠃⠀⠀⠀⡌⢸⠃⠀⠀⠀⢀⠀⠀⠑⢧⡸⠀⢀⣿⢻⡀⠀⠀⣻⠀⠀⠀⠀⠀⣠⡴⠛⠉⠀⠀⠀⠑⢝⣦⠀⠀⠀⢰⠠⠁⠀⠀
⠀⠀⠌⠀⠀⠀⡘⣖⣄⢃⠀⠀⠀⠈⢦⡀⠀⡜⡇⠀⣼⠃⠈⢷⣶⢿⠟⠀⠀⠀⢠⠞⠁⠀⣀⠄⠂⣶⣶⣦⠆⠋⠓⠀⢀⣀⡇⠀⠀⠀
⠡⡀⡇⠀⢰⣧⢱⠊⠘⡈⠄⠀⠀⡀⠘⣿⢦⣡⢡⢰⡇⢀⠤⠊⡡⠃⠀⠀⢀⡴⠁⢀⠔⠊⠀⠀⢠⣿⠟⠁⠀⢀⠀⢀⠾⣤⣀⠀⠀⡠
⡀⠱⡇⠀⡆⢃⠀⠀⠀⠃⠀⠀⠀⣧⣀⣹⡄⠙⡾⡏⠀⡌⣠⡾⠁⠀⠀⣠⠊⢠⠔⠁⠀⠀⠀⠀⣸⡏⠀⠀⠀⢨⣪⡄⢻⣥⠫⡳⢊⣴
⠀⠀⢡⢠⠀⢸⡆⠀⣀⠀⠀⠀⠀⠈⣛⢛⣁⣀⠘⣧⣀⢱⡿⠀⠀⢀⡔⢁⢔⠕⠉⠐⣄⣠⠤⠶⠛⠁⢀⣀⠀⠀⠉⠁⠈⠷⣞⠔⡕⣿
⢄⡀⠘⢸⠀⣘⠇⠀⠀⠀⠀⠀⠀⠀⠀⠉⠐⠤⡑⢎⡉⢨⠁⠀⣠⢏⠔⠁⠘⣤⠴⢊⣡⣤⠴⠖⠒⠻⠧⣐⠓⠀⠀⠀⠀⠈⠀⡜⠀⠇
⠤⡈⠑⠇⠡⣻⢠⠊⠉⠉⠉⠑⠒⠤⣀⠀⠀⠀⠈⣾⣄⢘⣫⣜⠮⢿⣆⡴⢊⢥⡪⠛⠉⠀⠀⠀⠀⢀⠄⠂⠁⠀⠀⠀⠀⠀⠀⢧⡀⠈
⠁⠈⠑⠼⣀⣁⣇⠀⣴⡉⠉⠉⠀⠒⡢⠌⣐⡂⠶⣘⢾⡾⠿⢅⠀⣠⣶⡿⠓⠁⢠⠖⣦⡄⠀⠀⠀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢎⢳
⠀⠀⠀⠀⠉⣇⣿⢜⠙⢷⡄⠀⠀⠀⣄⣠⠼⢶⡛⣡⢴⠀⢀⠛⠱⡀⠀⠀⠀⠀⢀⠎⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡋⠮⡈
⠀⠀⢀⣖⠂⢽⡈⠀⠈⠑⠻⡦⠖⢋⣁⡴⠴⠊⣉⡠⢻⡖⠪⢄⡀⢈⠆⠀⠀⢠⠊⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⡵⢤⣃
⠀⠀⠸⢠⡯⣖⢵⡀⠀⠀⣠⣤⠮⠋⠁⠀⠀⠀⠀⠀⠸⣌⢆⢱⡾⠃⢀⠠⠔⠁⣀⢸⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⡸⠚⡸⠈⠁
⠤⢀⣀⢇⢡⠸⡗⢔⡄⠸⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⡩⠔⢉⡠⠔⠂⠉⢀⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢁⠎⢀⡠⠔
⠀⠀⠀⠘⡌⢦⡃⣎⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠠⡟⠠⡐⣋⠤⠀⣀⠤⠐⠂⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⢉⠉⠁⠀⠀
⠤⠀⠀⠀⠰⡀⠈⠻⡤⠚⢄⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠈⠂⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⢸⠀⢀⠤⠊
⣀⠀⠀⠀⠀⠘⠢⡑⢽⡬⢽⢆⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⡶⠟⣉⣉⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠇⠀⠈⡖⠓⠒⠂
⠀⢈⣑⣒⡤⠄⠀⠈⠑⠥⣈⠙⠧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣁⠔⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⣠⡻⠀⠀⠀⠇⠐⡔⣡
⠉⠉⠁⠀⠒⠒⠒⠒⠀⠤⠤⠍⣒⡗⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠀⠀⢠⡞⢡⠃⠀⠀⠀⢸⠀⠸⣡
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠈⣶⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⣠⡔⠉⠀⡎⠀⠀⠀⠀⢸⠀⠀⠃
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⣀⢼⠀⠀⠀⢉⡄⠈⠐⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⡜⡡⣾⠃⠀⠀⠸⠀⠀⠀⠀⠀⠀⡧⢄⡈
⠀⠀⠀⠀⠀⠀⠀⣀⠤⠚⠉⠀⡆⠀⠀⠀⠈⡵⢄⡀⠀⠀⠙⠂⠄⣀⡀⠤⠊⠉⢀⣀⣠⡴⢿⣟⠞⠀⠀⢀⠇⠀⠀⠀⠀⠀⠀⡗⠢⢌
⠀⠀⠀⠀⡠⠔⠉⠀⠀⢀⡠⡤⠇⠀⠀⢀⠀⠰⣣⠈⠐⠤⡀⠀⡀⠈⠙⢍⠉⣉⠤⠒⠉⣠⣟⢮⠂⡄⠀⣼⠁⠀⡆⠀⠀⠀⠀⢡⣀⠀
⣿⡷⠖⠉⠀⠀⡠⠔⣪⣿⠟⣫⠀⠀⠀⢸⠀⠀⢩⢆⠀⠀⠈⠑⢳⠤⠄⠠⠭⠤⠐⠂⢉⣾⢮⠃⢠⠃⢰⡹⠀⢰⠀⠀⠀⠀⠀⢸⡉⣳
⠉⠀⢀⡠⠒⠉⣠⠾⠋⢁⠔⠹⠀⠀⠀⡈⡇⠀⠀⢫⣆⠀⠀⠀⠘⣆⠀⠀⠀⠀⠀⠀⣘⢾⠃⢀⠏⣠⡳⠁⠀⣾⠀⠀⠀⠀⠀⠀⠈⠉


                  ¡CUIDA TUS PALABRAS MALDITO INSECTO!
