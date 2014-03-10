## read in commute mode (public transit) 
## public transportation to work:              pos: 3 = state, pos: 6 = logrecno
## B08301_001 total workers over 16  	seq: 28, pos: 157
## B08301_010 travel to work by public transit	seq: 28, pos: 166

cols = c(3,6,157,166)
folder = "E:/FromArminPC/All_Geographies_Not_Tracts_Block_Groups.tar/All_Geographies_Not_Tracts_Block_Groups/group1/"
commute = data.frame()
commute_list = list()
for (state in states){
  rf = paste(folder,"e20115",state,"0028000.txt",sep="")
  rf = file(rf,"r") # open read connection
  while(TRUE){
    rl = readLines(rf,n=1)
    if(length(rl)==0) break # end of file
    rl = strsplit(rl,split=",")[[1]]
    rl = rl[cols]
    state_logrecno = paste(rl[1],rl[2],sep="")
    keep = state_logrecno %in% csm$state_logrecno
    if (keep){
      commute_list = c(commute_list,rl)
    }
  }
  commute_state = data.frame(matrix(unlist(commute_list), ncol=4, byrow=T))
  commute = rbind(commute,commute_state)
  commute_list = list()
}

names(commute) = c("state","logrecno","comm","tran")
commute$state_logrecno = paste(commute$state,
                               commute$logrecno,
                               sep="")
commute$comm = as.numeric(as.character(commute$comm))
commute$tran = as.numeric(as.character(commute$tran))
commute$tran_p = commute$tran/commute$comm