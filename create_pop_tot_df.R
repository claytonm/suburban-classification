## read in
# Total Population:
#   B00001_001  				seq: 2, pos: 7
cols = c(3,6,7)
folder = "E:/FromArminPC/All_Geographies_Not_Tracts_Block_Groups.tar/All_Geographies_Not_Tracts_Block_Groups/group1/"
pop_tot = data.frame()
pop_tot_list = list()
for (state in states){
  rf = paste(folder,"e20115",state,"0002000.txt",sep="")
  rf = file(rf,"r") # open read connection
  while(TRUE){
    rl = readLines(rf,n=1)
    if(length(rl)==0) break # end of file
    rl = strsplit(rl,split=",")[[1]]
    rl = rl[cols]
    state_logrecno = paste(rl[1],rl[2],sep="")
    keep = state_logrecno %in% csm$state_logrecno
    if (keep){
      pop_tot_list = c(pop_tot_list,rl)
    }
  }
  pop_tot_state = data.frame(matrix(unlist(pop_tot_list), ncol=3, byrow=T))
  pop_tot = rbind(pop_tot,pop_tot_state)
  pop_tot_list = list()
}

names(pop_tot) = c("state","logrecno","pop")
pop_tot$state_logrecno = paste(pop_tot$state,
                               pop_tot$logrecno,
                               sep="")
pop_tot$pop = as.numeric(as.character(pop_tot$pop))
