library(gdata)
cs = data.frame() ## County Subdivisions data frame
folder = paste(getwd(),"/geo_files/",sep = "")
states = c("ak","al","ar","az","ca","co","ct","dc","de","fl","ga","hi","ia","id","il","in","ks","ky","la","ma","md","me","mi","mn","mo","ms","mt","nc","nd","ne","nh","nj","nm","nv","ny","oh","ok","or","pa","pr","ri","sc","sd","tn","tx","ut","va","vt","wa","wi","wv","wy")
for (state in states){
  file_xls = paste(folder,state,".xls",sep="")
  file_csv = paste(folder,state,".csv",sep="")
  write.csv(read.xls(file_xls),
            file_csv)
  csv = read.csv(file_csv,
                as.is=TRUE)
  cs = rbind(cs,csv)
}

## remove unnecessary column and rename remaining columns
cs = cs[,-1]
names(cs) = c("state","logrecno","GEOID10","geoname")

## pad logrecno with 0s
cs$logrecno = sapply(cs$logrecno,pad_left,USE.NAMES=FALSE)

## remove non cousub geographies
cs = subset(cs,substr(GEOID10,start=1,stop=2)=="06")

## add county id column
cs$county_id = substr(cs$GEOID10,
                      start = regexpr("US",cs$GEOID10)+2,
                      stop = regexpr("US",cs$GEOID10)+6)

## add msa column from msa df
xnames = names(cs)
ynames = c("cbsa","metropolitan_micropolitan")
cs = merge(cs,
           msa,
           by.x="county_id",
           by.y="county_id",
           all.x=TRUE,
           suffixes="")[c(xnames,ynames)]

## create csm to contain only *County *Subdivions in a *MSA
csm = subset(cs,metropolitan_micropolitan=="Metropolitan Statistical Area")
csm$state = tolower(csm$state)
csm$state_logrecno = paste(csm$state,csm$logrecno,sep="")
