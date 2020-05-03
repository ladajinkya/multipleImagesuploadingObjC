<?php
    require('NewConnection.php');
    $connection=mysqli_connect($host , $user , $password , $db);
    if(isset($_REQUEST['tag']) )
    {
        $tag=$_REQUEST['tag'];
        if($tag=="floor")
        {
            $target_path = "uploads/";
            $count=$_REQUEST['count'];
            $updatename="";
            date_default_timezone_set('UTC');
            
            $target_path = "uploads/";
            
            for($i=0; $i<$count; $i++)
            {
                $post_name="file".($i+1);
                $name='DW_'.$i.'.png';
                $target_path = 'uploads/'.$name;
                if (!move_uploaded_file($_FILES[$post_name]['tmp_name'], $target_path)) {
                    throw new Exception('Could not move file');
                }
                
                if($updatename=="")
                    $updatename=$name;
                else
                    $updatename=$updatename."|".$name;
                
            }
            $sqluser = "INSERT INTO tbl_dummy (ImgName)
            VALUES ('$updatename')";
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
        
    }
    else
    {
        $response[] = array(
                            "success" => "0",
                            "result"=>"tag Not send"
                            );
    }
    echo json_encode($response);
    ?>
