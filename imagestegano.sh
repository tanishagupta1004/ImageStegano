#!/bin/bash

figlet -f big Imagestegano
echo -e "\t#************************************************#"
echo -e "\t#                                                #"
echo -e "\t#                   ROSP MPR                     #"
echo -e "\t#                 Group No: 09                   #"
echo -e "\t#                Prof. Sanjay Pandey             #"
echo -e "\t#                                                #"
echo -e "\t#                                                #"
echo -e "\t#************************************************#"
echo ""

PS3='Please enter your choice: '
options=("Encrypt" "Decrypt" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Encrypt")
            echo ""
            img_path=$(zenity --file-selection --title="Select an image for hiding data")
            if [ -z "$img_path" ]; then
                echo "Image selection canceled or no file selected. Aborting."
                exit 1
            fi
            echo ""
            file_path=$(zenity --file-selection --title="Select a file or folder to encrypt")
            if [ -z "$file_path" ]; then
                echo "File selection canceled or no file selected. Aborting."
                exit 1
            fi
            echo ""
            newimage=$(zenity --entry --title="Enter a name for your encrypted image")
            if [ -z "$newimage" ]; then
                echo "No name entered for the encrypted image. Aborting."
                exit 1
            fi
            echo ""
            zenity --question --title="Encrypt with Password" --text="Do you want to encrypt your file with a password after extracting it from the image?"
            encrypt_choice=$?

            if [ $encrypt_choice -eq 0 ]; then
                zip -e $newimage.zip $file_path
            else
                zip $newimage.zip $file_path
            fi

            cat $img_path $newimage.zip >$newimage.jpeg
            rm $newimage.zip
            echo "Congratulations, your encrypted image file is saved successfully."

            echo "1) Encrypt"
            echo "2) Decrypt"
            echo "3) Quit"
            echo ""
            ;;
        "Decrypt")
            echo "Select the encrypted image to decrypt:"
            img2_path=$(zenity --file-selection --title="Select an encrypted image to decrypt")
            if [ -z "$img2_path" ]; then
                echo "Image selection canceled or no file selected. Aborting."
                exit 1
            fi
            mv "$img2_path" decrypted.zip
            mkdir Decrypted_Files
            unzip -j decrypted.zip -d Decrypted_Files
            rm decrypted.zip
            echo "Files decrypted successfully and saved in your system."

            echo "1) Encrypt"
            echo "2) Decrypt"
            echo "3) Quit"
            echo ""
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done
