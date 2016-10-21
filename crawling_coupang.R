#######################################################################
#                                                                     #
#                         Crawling Coupang                            #
#                                                                     #
#                           Oct 4, 2016                               #
#######################################################################

library(rvest)
library(RCurl)
library(httr)

mainDir <- "~/Desktop"
subDir <- "output"

dir.create(file.path(mainDir, subDir))
setwd(file.path(mainDir, subDir))

# Crawling Beauty
b_id<-c(108460,108462,108464,108480,108494,108506,108514,108516,108524,108531,108539,108543,108545,108564,108581,126686,126687,108636,
        108638,108650,108668,126689,108715,108717,108721,108729,108741,108753,108775,108776,108778,108785,108791,108796,108803,108807,
        108811,108813,108814,108815,108817,108819,108823,108827)
b_name<-c("뷰티","스킨케어","기초화장품","클랜징/필링","마스크/팩","선케어/태닝",
          "메이크업","아이 메이크업","립 메이크업","베이스 메이크업","치크/기타 메이크업",
          "헤어","샴푸","린스/컨디셔너","트리트먼트/팩/앰플","스타일링/케어/세트","염색/펌",
          "바디","샤워/입욕용품","바디로션/크림","핸드/풋/데오","제모/슬리밍/청결제",
          "네일","큐티클/영양","일반네일","젤네일","네일케어도구","네일아트소품/도구","네일세트",
          "뷰티소품","아이소품","페이스소품","클렌징소품","헤어소품","바디소품","용기/거울/기타소품",
          "향수","여성향수","남성향수","롤온/고체향수",
          "남성화장품","남성스킨케어","남성메이크업","남성화장품세트")
beauty <- data.frame(b_id, b_name) 
beauty$b_name<-as.character(beauty$b_name)

result<-NULL
for(j in 1:nrow(beauty))
{
  print(paste0("Current Category: ",beauty$b_name[j]))
  for(i in 1:5)
  {
    bestitems<-NULL
    coupang_url<-paste0("https://www.coupang.com/np/best100/sub/async/bestseller/",beauty$b_id[j],"/",i)
    page<-html_session(coupang_url)
    item_nm<-page %>% html_nodes("dd.name") %>% html_text()
    price<-page %>% html_nodes("strong.price-value") %>% html_text()
    rating<-page %>% html_nodes("em.rating") %>% html_text()
    rate_cnt<-page %>% html_nodes("span.rating-total-count") %>% html_text()
    rate_cnt<-gsub("\\(","",rate_cnt)
    rate_cnt<-gsub("\\)","",rate_cnt)
    purchased<-page %>% html_nodes("div.condition")
    purchased<-as.character(purchased)
    remove1<-"<div class=\"condition\">\n                        <!---->\n                            <!---->\n                                <!---->\n                                    <!---->\n                                        <!--<em>"
    remove2<-"</em>-->\n                                    <!---->\n                                <!---->\n                            <!---->\n                        <!---->\n                    </div>"
    purchased<-gsub(remove1,"",purchased)
    purchased<-gsub(remove2,"",purchased)
    category <-beauty$b_name[j]
    date<-Sys.Date()
    time<-Sys.time()
    source<-"Coupang Top 100"
    bestitems<-cbind(item_nm,price,rating,rate_cnt,purchased,category,date,time,source)
    bestitems<-as.data.frame(bestitems)
    result<-rbind(result,bestitems)
    print(paste0("Current Page: ",i))
    Sys.sleep(1)
  }
}


write.csv(result,paste0("coupang_result_",Sys.Date(),".csv"),row.names = FALSE)

quit(save="no")
