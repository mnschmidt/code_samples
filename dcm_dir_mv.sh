#!/usr/bin/env bash

#######################################################################################
# This script organizes a directory full of dicoms into a series of sub-directories
# grouped by sequence name and instance number.
#
# Created: 08/06/2012
# Edited:  11/06/2012
# Author: Marcus Schmidt
#
#######################################################################################

# UMASK = set default permissions for current working session
# INFO
# Octal value : Permission
# 0 : read, write and execute
# 1 : read and write
# 2 : read and execute
# 3 : read only
# 4 : write and execute
# 5 : write only
# 6 : execute only
# 7 : no permissions

umask 003 # equiv to chmod 775

src_dir="$1"

base_dir="/Volumes/vgraid/mr_data/received_dicom"

# the following allows the script to be run by storescp (provides entire path to src_dir), as well as from command line
if [[ -d ${src_dir} ]]; then
	cd ${src_dir}
elif [[ -d ${base_dir}/${src_dir} ]]; then
	cd ${base_dir}/${src_dir}
else
	echo " "
	echo "Error: could not find input directory"
	exit
fi

# recursively change file ownership and permissions
chown -R mriadmin:mrdatausers . ; chmod -R 775 .

# get first dicom in src_dir
first_dicom=`ls -1 |grep -m 1 dcm`

# set variables to be used by mark_as_received.rb, once the dicoms have been organized into sub-directories within src_dir
patient_name=`/usr/bin/dcmdump +P PatientName $first_dicom | sed -e 's/^[^[]*\[//' -e 's/\].*//' | cut -d'^' -f2`
r_number=`echo $patient_name | cut -d'_' -f1`
event_id=`echo $patient_name | cut -d'_' -f2`


# ORGANIZE INPUT DIRECTORY
for file in $(ls -1); do
	# if file is dicom, continue
	if [[ `/usr/bin/dcmftest $file | cut -d':' -f1` = "yes" ]]; then
		# Extract series number and description from file
		SeriesNumber=`/usr/bin/dcmdump +P SeriesNumber $file | sed -e 's/^[^[]*\[//' -e 's/\].*//'`
		InstanceNumber=`/usr/bin/dcmdump +P InstanceNumber $file  | sed -e 's/^[^[]*\[//' -e 's/\].*//'`
		x=`/usr/bin/dcmdump +P SeriesDescription $file | sed -e 's/^[^[]*\[//' -e 's/\].*//'`
		SeriesDescription=${x// /_}
		paddedSeriesNumber=`printf "%04d" ${SeriesNumber}`
		paddedSliceNumber=`printf "%04d" ${InstanceNumber}`
		# Do something useful with $file
		dest_dir="${SeriesDescription}"_"${SeriesNumber}"/
		if [[ ! -d $dest_dir ]]; then
		mkdir -p "$dest_dir"
		fi
		# if file destination doesn't exist, move current file there (this protects against overwrites)
		if [[ ! -e "$dest_dir""${paddedSeriesNumber}_${paddedSliceNumber}.dcm" ]]; then
			mv "$file" "$dest_dir""${paddedSeriesNumber}_${paddedSliceNumber}.dcm"
		fi
	fi
done

# TRY TO MARK AS RECEIVED IN MAYO
/Volumes/vgraid/mr_data/scripts/dcm_receiver/mark_as_received_v2.rb $base_dir $src_dir $r_number $event_id
