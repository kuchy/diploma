<?php
function randomcode() {   //komentarik
  $var = "abcdefghijkmnopqrstuvwxyz0123456789";
  srand((double)microtime()*1000000);
  $i = 0;
  while ($i <= 7) {
    $num = rand() % 33;
    $tmp = substr($var, $num, 1);
    if (isset($code))  {
      $code = $code . $tmp;
    }
    $i++;
  }
  return $code;
  }
?>