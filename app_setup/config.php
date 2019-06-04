<?php

$databaseHost = ${DB_HOST};
$databaseName = ${DB_NAME};
$databaseUsername = ${DB_USER};
$databasePassword = ${DB_PASSWORD};

$mysqli = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName); 
 
?>
