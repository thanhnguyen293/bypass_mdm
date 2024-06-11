#!/bin/bash
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'
echo ""
echo -e "Auto Tools for MacOS"
echo ""
PS3='Please enter your choice: '
options=("Bypass on Recovery" "Disable Notification (SIP)" "Disable Notification (Recovery)" "Check MDM Enrollment" "Thoát")
select opt in "${options[@]}"; do
	case $opt in
	"Bypass on Recovery")
		echo -e "${GRN}Bypass on Recovery"
		if [ -d "/Volumes/Hackintosh HD - Data" ]; then
   			sudo diskutil rename "Hackintosh HD - Data" "Data"
		fi
		echo -e "${GRN}Tạo người dùng mới"
        echo -e "${BLU}Nhấn Enter để chuyển bước tiếp theo, có thể không điền sẽ tự động nhận giá trị mặc định"
  		echo -e "Nhập tên người dùng (Mặc định: MAC)"
		read realName
  		realName="${realName:=MAC}"
    	echo -e "${BLUE}Nhận username ${RED}VIẾT LIỀN KHÔNG DẤU ${GRN} (Mặc định: MAC)"
      	read username
		username="${username:=MAC}"
  		echo -e "${BLUE}Nhập mật khẩu (mặc định: 1234)"
    	read passw
      	passw="${passw:=1234}"
		dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default' 
        echo -e "${GREEN}Đang tạo user"
  		# Create user
    	sudo dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
      	sudo dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
	    sudo dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	 	sudo dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	    sudo dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
	    sudo dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
		mkdir "/Volumes/Data/Users/$username"
	    sudo dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
	    sudo dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
	    sudo dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
		echo "0.0.0.0 deviceenrollment.apple.com" >>/Volumes/Hackintosh\ HD/etc/hosts
		echo "0.0.0.0 mdmenrollment.apple.com" >>/Volumes/Hackintosh\ HD/etc/hosts
		echo "0.0.0.0 iprofiles.apple.com" >>/Volumes/Hackintosh\ HD/etc/hosts
        echo -e "${GREEN}Chặn host thành công${NC}"
		# echo "Remove config profile"
  	sudo touch /Volumes/Data/private/var/db/.AppleSetupDone
        rm -rf /Volumes/Hackintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	sudo rm -rf /Volumes/Hackintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	sudo touch /Volumes/Hackintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	sudo touch /Volumes/Hackintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
		echo "----------------------"
		break
		;;
    "Disable Notification (SIP)")
    	echo -e "${RED}Please Insert Your Password To Proceed${NC}"
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
    "Disable Notification (Recovery)")
        sudo rm -rf /Volumes/Hackintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	sudo rm -rf /Volumes/Hackintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	sudo touch /Volumes/Hackintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	sudo touch /Volumes/Hackintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

        break
        ;;
	"Check MDM Enrollment")
		echo ""
		echo -e "${GRN}Check MDM Enrollment. Error is success${NC}"
		echo ""
		echo -e "${RED}Please Insert Your Password To Proceed${NC}"
		echo ""
		sudo profiles show -type enrollment
		break
		;;
	"Quit")
		break
		;;
	*) echo "Invalid option $REPLY" ;;
	esac
done