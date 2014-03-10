## read in
# Tenure: 
# B25008_001 total housing units  		seq: 99, pos: 11
# B25008_003 renter                   seq: 99, pos: 13
cols = c(3,6,11,13)
folder = "E:/FromArminPC/All_Geographies_Not_Tracts_Block_Groups.tar/All_Geographies_Not_Tracts_Block_Groups/group1/"
tenure = data.frame()
tenure_list = list()
for (state in states){
  rf = paste(folder,"e20115",state,"0099000.txt",sep="")
  rf = file(rf,"r") # open read connection
  while(TRUE){
    rl = readLines(rf,n=1)
    if(length(rl)==0) break # end of file
    rl = strsplit(rl,split=",")[[1]]
    rl = rl[cols]
    state_logrecno = paste(rl[1],rl[2],sep="")
    keep = state_logrecno %in% csm$state_logrecno
    if (keep){
      tenure_list = c(tenure_list,rl)
    }
  }
  tenure_state = data.frame(matrix(unlist(tenure_list), ncol=4, byrow=T))
  tenure = rbind(tenure,tenure_state)
  tenure_list = list()
}

names(tenure) = c("state","logrecno","o","ro")
tenure$state_logrecno = paste(tenure$state,
                              tenure$logrecno,
                              sep="")
tenure$o = as.numeric(as.character(tenure$o))
tenure$ro = as.numeric(as.character(tenure$ro))
tenure$ro_p = tenure$ro/tenure$o

