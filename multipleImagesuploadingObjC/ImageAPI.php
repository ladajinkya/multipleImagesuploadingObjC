<?php
require('NewConnection.php');
$connection=mysqli_connect($host , $user , $password , $db);
     $tag=$_REQUEST['tag'];
     $ImgName=$_REQUEST['ImgName'];
     if($tag=="floor")
     {
         $target_path = "uploads/";
         $updatename="";
         date_default_timezone_set('UTC');
             $post_name="ImgName";
            // $post_name1="ImgName";
             $target_path = 'uploads/'.$ImgName;
             if (!move_uploaded_file($_FILES[$post_name]['tmp_name'], $target_path)) {
                 throw new Exception('Could not move file');
             }
         if($updatename=="")
             $updatename=$ImgName;
         else
             $updatename=$updatename."|".$ImgName;
                 
                $sqluser = "INSERT INTO tbl_dummy (ImgName)
                 VALUES ('$updatename')";
                 // "INSERT INTO tbl_dummy (ImgName) VALUES '$updatename'";
              //$resultuser = mysqli_query($connection, $sqluser);
         
         if ($conn->query($sqluser) === TRUE)
         {
             
             $response[] = array(
                                 "success" => "1",
                                 "result" =>"inserted"
                                 );
         }
         else
         {
             $response[] = array(
                                 "success" => "0",
                                 "result" =>"".$sqluser
                                 );
         }
    
         
     }
     else
     {
         $response[] = array(
                             "success" => "0",
                             "result"=>"tag Not match"
                             );
     }
 echo json_encode($response);
 ?>
