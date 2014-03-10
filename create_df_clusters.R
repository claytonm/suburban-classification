df_complete = df[complete.cases(combined),]

df_clusters = data.frame()
for (cbsa in unique(df_complete$cbsa)){
  df_temp = df_complete[df_complete$cbsa == cbsa,]
  if (nrow(df_temp)<=2) next
  df_pam = pam(df_temp[,c(5:7,9)],k=2,diss=F)
  df_temp$cluster = df_pam$cluster
  df_temp$silinfo = df_pam$silinfo$width[,3]
  df_clusters = rbind(df_clusters,df_temp)
}

## add city/suburb labels to each cbsa according to 
## label of city with largest population in cbsa
df = data.frame()
for (cbsa in unique(df_clusters$cbsa)){
  df_temp = df_clusters[df_clusters$cbsa==cbsa,]
  max_pop = max(df_temp$pop,na.rm=TRUE)
  max_clust = df_temp$cluster[which(df_temp$pop==max_pop)]
  df_temp$clust_label = ifelse(df_temp$cluster==max_clust,
                               "city",
                               "suburb")
  df = rbind(df,df_temp) 
}

df_clusters = df