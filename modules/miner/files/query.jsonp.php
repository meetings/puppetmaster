<?php

$data = '';

if ( hash("sha256", $_GET["secret"] ) != "x" ) {
  exit();
}

if ( $_GET["mikko_sql"] ) {
  $data_sql = $_GET["mikko_sql"];
}
else {
  $URL = 'https://admin:meatings@sites.meetin.gs/admin/sql/' . $_GET["sql"];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_URL, $URL);
  $data_sql = rtrim( curl_exec($ch) );
  curl_close($ch);
}

$args = $_GET["args"];
if ( $args ) {
  if ( preg_match('/"/', $data_sql ) ) {
    die('FOR SECURITY REASONS YOU MUST USE \' INSTEAD OF " IN SQL THAT USES ARGUMENTS');
  }

  $argsarray = array();

  $args_data = json_decode( $args );
  foreach( $args_data as $val ) {
    $val = "" . $val;
    $val = preg_replace("/\\\\/","\\\\\\\\", $val);
    $val = preg_replace("/\\'/","\\'", $val);
    array_push( $argsarray, $val );
  }

  $data_sql = vsprintf( $data_sql, $argsarray );
}

$mysqli = new mysqli("localhost", "miner", "miner", "miner_data");
$result = $mysqli->query( $data_sql );
$rows = array();
if ( preg_match("/^\\s*select/", strtolower($data_sql) ) ) {
  while ( $r = $result->fetch_assoc() ) {
    $rows[] = $r;
  }
}
$callback = $_GET["callback"];
$callback = $callback ? $callback : 'callback';
header('Content-Encoding: gzip');
header("Content-Type: application/javascript");

$data .= $callback . "(" . json_encode($rows) . ");";
echo gzencode($data, 1);
