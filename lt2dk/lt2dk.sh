FILEPATH=$1
FILE=$(basename "${FILEPATH}")
WORKDIR=$(dirname "${FILEPATH}")
OUT=${FILE%.*}

cd $WORKDIR
mkdir img
pdftoppm $FILE img/$OUT -png

len=$(pdfinfo $FILE | grep Pages | awk '{print $2}')
for i in $(seq -f "%02g" 1 $len)
do
    ffmpeg -i img/${OUT}-${i}.png -hide_banner -loglevel panic -vf negate,eq=brightness=.25:contrast=1.15,colorkey=white -c:a copy img/${OUT}_dark-${i}.png
    ffmpeg -i img/${OUT}_dark-${i}.png -hide_banner -loglevel panic -filter_complex "[0]split=2[bg][fg];[bg]drawbox=c=0xE1E1E1@1:replace=1:t=fill[bg]; [bg][fg]overlay=format=auto" -c:a copy img/${OUT}_dark-${i}_${i}.png
    rm img/${OUT}-${i}.png
    rm img/${OUT}_dark-${i}.png
done

convert img/*.png ${OUT}_dark.pdf
rm -r img