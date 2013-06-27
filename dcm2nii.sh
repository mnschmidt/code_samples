#!/usr/bin/env bash

#######################################################################################
# This script converts a dicom series to a nifti file, using the dcm2nii binary.
# It is designed to be called by a pipeline script, but can be used on it's own if 
# supplied with the proper parameters.
#
# Usage w/o pipeline: ./dcm2nii.sh R-number EventID image_sequence study
# 				i.e.: ./dcm2nii.sh R123456 100801 t1 100_GRP
#
# Created: 31/01/2012
# Edited:  11/01/2013
# Author: Marcus Schmidt
#
#######################################################################################

USAGE="Usage: ./dcm2nii.sh r_number event_id image_sequence study"

# if there are less than four arguements, give an error and example usage
if [[ -z "$4" ]]; then
	echo "ERROR. $USAGE"
	echo "Example: ./dcm2nii.sh R123456 100890 dti 100_GRP"
	exit
fi

# set the first argument as R_NUMBER and the second argument as EVENTID, third as image sequence and fourth as study prefix
R_NUMBER=${1}
EVENTID=${2}
IMG_SEQ=${3}
STUDY=${4}

# set USER to current user if it's not already set
if [[ $USER = "" ]]; then
	USER=`whoami`
fi

# set our in-script variables
IN_DIR="/Volumes/vgraid/mr_data/dicom/${STUDY}/${R_NUMBER}/${EVENTID}"
OUT_DIR="/Volumes/vgraid/mr_data/nii/${STUDY}/${R_NUMBER}/${EVENTID}"

IMG="${IMG_SEQ}_${R_NUMBER}_${EVENTID}"

SUBJECTS_DIR="/Volumes/vgraid/mr_data/structural"

# go to subject's dicom directory
cd $IN_DIR

# get the number of slices collected for the image sequence specified and set DCM_DIR to the image sequence's dicom directory
case "$IMG_SEQ" in
	t1 ) IMG_SLICES=`ls -1 ${IN_DIR}/IR*FSPGR*/ | wc -l`
	DCM_DIR=`ls -1 | grep IR*FSPGR*`
		;;
	pd ) IMG_SLICES=`ls -1 ${IN_DIR}/Ax*PD*/ | wc -l`
	DCM_DIR=`ls -1 | grep Ax*PD*`
		;;
	dti ) IMG_SLICES=`ls -1 ${IN_DIR}/Ax*DTI*/ | wc -l`
	DCM_DIR=`ls -1 | grep Ax*DTI*`
		;;
esac

# if the image is a t1 and there are less than 186 slices, skip conversion
if [ "$IMG_SEQ" == "t1" -a "$IMG_SLICES" -lt 186 ]; then
	exit
fi
# if the image is a pd and there are less than 154 slices, skip conversion
if [ "$IMG_SEQ" == "pd" -a "$IMG_SLICES" -lt 154 ]; then
	exit
fi
# if the image is a dti and there are less than 2926 slices, skip conversion
if [ "$IMG_SEQ" == "dti" -a "$IMG_SLICES" -lt 2926 ]; then
	exit
fi
# if the image is a fieldmap and there are less than 344 slices, skip conversion
if [ "$IMG_SEQ" == "fieldmap" -a "$IMG_SLICES" -lt 344 ]; then
	exit
fi

# if the subject's given image sequence hasn't been converted to nifti, proceed
if [[ ! -e $OUT_DIR/$IMG.nii.gz ]]; then
	echo " "
	echo "Output directory = $OUT_DIR"
	echo " "
	echo "$IMG.nii.gz not found in $OUT_DIR. Creating $IMG.nii.gz"
	echo " "
	echo "$IMG_SLICES slices found."
	# check if the subject has a directory for this session's nifti formatted data
	if [[ ! -d ${OUT_DIR} ]]; then
		echo " "
		echo "mkdir -p ${OUT_DIR}"
		mkdir -p ${OUT_DIR}
	fi
	
# copy the subject's dicom data for the given image sequence to /tmp (so any changes we make can be restored)
	if [[ -d /tmp/$USER/$R_NUMBER ]]; then
		echo " "
		echo "Discovered previous session's temp data... removing"
		echo "rm -R /tmp/$USER/$R_NUMBER"
		rm -R /tmp/$USER/$R_NUMBER
	fi
	
	echo " "
	echo "Creating temporary dicom directory."
	echo "mkdir -p /tmp/$USER/$R_NUMBER"
	mkdir -p /tmp/$USER/$R_NUMBER
	
	echo " "
	echo "Making backup of dicom files before proceeding..."
	echo "cp -R $IN_DIR/$DCM_DIR /tmp/$USER/$R_NUMBER/"
	cp -R $IN_DIR/$DCM_DIR /tmp/$USER/$R_NUMBER/
	##rlm added perms change on Sept14 2012.
	chmod -R 770 /tmp/$USER/$R_NUMBER
	echo "cd /tmp/$USER/$R_NUMBER/$DCM_DIR"
	cd /tmp/$USER/$R_NUMBER/$DCM_DIR

	# get name of first dicom which will then be used as the input for dcm2nii
	x=`ls -1 |grep -m 1 dcm`
	y=${x%.dcm}
	firstfile=`echo "$y" | sed 's/[\.]//g'`
	echo " "
	echo "firstfile: $firstfile"

	# convert from dicom to nii using dcm2nii
	echo " "
	echo "dcm2nii -i N -b /Volumes/vgraid/mr_data/scripts/dcm2nii.ini -f Y -p N -e N -d N -v Y /tmp/$USER/$R_NUMBER/$DCM_DIR"
	echo " "
	/usr/bin/dcm2nii -i N -b /Volumes/vgraid/mr_data/scripts/dcm2nii.ini -g Y -f Y -p N -e N -d N -v Y /tmp/$USER/$R_NUMBER/$DCM_DIR

	# rename the output files
	if [[ $IMG_SEQ == 't1' ]]; then
		# if it's a t1...
		echo " "
		echo "Renaming output files..."
		echo "mv o${firstfile}.nii.gz ${IMG}.nii.gz"
		mv o${firstfile}.nii.gz ${IMG}.nii.gz
	else
		# if it's anything but a t1
		echo " "
		echo "Renaming output files..."
		echo "mv ${firstfile}.nii.gz ${IMG}.nii.gz"
		mv $firstfile.nii.gz ${IMG}.nii.gz
		# if image sequence is DTI, also rename the bval and bvec files
		if [ "$IMG_SEQ" == "dti" ]; then
			echo "mv $firstfile.bval ${IMG}.bval"
			mv $firstfile.bval ${IMG}.bval
			echo "mv $firstfile.bvec ${IMG}.bvec"
			mv $firstfile.bvec ${IMG}.bvec
		fi
	fi

	# move nifti file from tmp directory to subject's nii directory
	echo " "
	echo "Moving output files to subject's output directory..."
	echo "mv ${IMG}.nii.gz $OUT_DIR/"
	mv ${IMG}.nii.gz $OUT_DIR/
	# if image sequence is DTI, also move the bval and bvec files to the output directory
	if [ "$IMG_SEQ" == "dti" ]; then
		echo "mv ${IMG}.bval $OUT_DIR/"
		mv ${IMG}.bval $OUT_DIR/
		echo "mv ${IMG}.bvec $OUT_DIR/"
		mv ${IMG}.bvec $OUT_DIR/
	fi
fi

# FREESURFER SECTION
if [[ "$IMG_SEQ" == "t1" && -e ${OUT_DIR}/${IMG}.nii.gz ]]; then
	if [[ ! -d ${SUBJECTS_DIR}/${R_NUMBER} ]]; then
		echo "No FreeSurfer output directory found for subject ${R_NUMBER}."
		echo "Looking to see if subject ${R_NUMBER} is in waiting list"
		# continue if the subject doesn't have a freesurfer directory
		if [[ ! -e ${SUBJECTS_DIR}/waiting_list/${R_NUMBER}/mri/orig/001.mgz ]]; then
			echo "MGZ file for subject ${R_NUMBER} not found in waiting list"
			# continue if the mgz doesn't exist
			if [[ ! -d ${SUBJECTS_DIR}/waiting_list/${R_NUMBER}/mri/orig ]]; then
				# create proper directories if they don't already exist
				echo " "
				echo "mkdir -p ${SUBJECTS_DIR}/waiting_list/${R_NUMBER}/mri/orig"
				mkdir -p ${SUBJECTS_DIR}/waiting_list/${R_NUMBER}/mri/orig
			fi
			echo "Adding subject ${R_NUMBER} to FreeSurfer waiting list..."
			cd $IN_DIR
			T1_DIR=`ls -1 | grep IR*FSPGR*`
			cd $T1_DIR
			firstFile=`ls -1 | grep -m 1 dcm`
			echo "mri_convert -it dicom -ot mgz $firstFile ${SUBJECTS_DIR}/waiting_list/${R_NUMBER}/mri/orig/001.mgz"
			mri_convert -it dicom -ot mgz $firstFile ${SUBJECTS_DIR}/waiting_list/${R_NUMBER}/mri/orig/001.mgz
		else
			echo "Subject was found in waiting list."
		fi
		# set the permissions so everyone in mrdatausers group can r+w
		chown -Rf :mrdatausers ${SUBJECTS_DIR}/waiting_list/${R_NUMBER}
		chmod -Rf 775 ${SUBJECTS_DIR}/waiting_list/${R_NUMBER}
	fi
fi
