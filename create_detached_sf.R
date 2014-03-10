## read in
# One Unit Detached housing:    pos: 3 = state, pos: 6 = logrecno
# B25024_001 total housing units    	seq: 100, pos: 73	
# B25024_002 one unit detached 			seq: 100, pos: 74
cols = c(3,6,73,74)
folder = "All_Geographies_Not_Tracts_Block_Groups.tar/All_Geographies_Not_Tracts_Block_Groups/group1/"
one_unit = data.frame()
one_unit_list = list()
for (state in states){
  rf = paste(folder,"e20115",state,"0100000.txt",sep="")
  rf = file(rf,"r") # open read connection
  while(TRUE){
    rl = readLines(rf,n=1)
    if(length(rl)==0) break # end of file
    rl = strsplit(rl,split=",")[[1]]
    rl = rl[cols]
    state_logrecno = paste(rl[1],rl[2],sep="")
    keep = state_logrecno %in% csm$state_logrecno
    if (keep){
      one_unit_list = c(one_unit_list,rl)
    }
  }
  one_unit_state = data.frame(matrix(unlist(one_unit_list), ncol=4, byrow=T))
  one_unit = rbind(one_unit,one_unit_state)
  one_unit_list = list()
}

names(one_unit) = c("state","logrecno","hu","u_1")
one_unit$state_logrecno = paste(one_unit$state,
                                one_unit$logrecno,
                                sep="")

one_unit$hu = as.numeric(as.character(one_unit$hu))
one_unit$u_1 = as.numeric(as.character(one_unit$u_1))
one_unit$u_1_p = one_unit$u_1/one_unit$hu