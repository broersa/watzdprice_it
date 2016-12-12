#!/bin/bash
ELASTIC_URL="http://localhost:9200"
ELASTIC_INDEX="nl-nl"

# docker-compose up -d
# while : ; do
#     STATUSCODE=$(curl --silent --output /dev/stderr --write-out "%{http_code}" $ELASTIC_URL)
#     echo $STATUSCODE
#     [ $STATUSCODE -ne 503 ] || break
#     sleep 10
# done

# docker-compose scale master=3 data=3
# while : ; do
#     STATUSCODE=$(curl --silent --output /dev/stderr --write-out "%{http_code}" $ELASTIC_URL)
#     echo $STATUSCODE
#     [ $STATUSCODE -ne 200 ] || break
#     sleep 10
# done
# curl -XGET "$ELASTIC_URL/_cluster/health?wait_for_status=green"

echo "delete index just to be sure"
curl -XDELETE "$ELASTIC_URL/$ELASTIC_INDEX/"; echo
curl -XPUT "$ELASTIC_URL/$ELASTIC_INDEX/" -d '
{
  "settings" : {
    "number_of_shards" : 3,
    "number_of_replicas" : 1,
    "analysis" : {
      "analyzer" : {
        "productname" : {
          "type" : "custom",
          "tokenizer" : "standard",
          "filter" : [ "standard", "wdpfilter1", "wdpfilter2", "lowercase", "unique" ]
        }
      },
      "filter" : {
        "wdpfilter1" : {
          "type" : "word_delimiter",
          "preserve_original" : true
        }, 
        "wdpfilter2" : {
          "type" : "word_delimiter",
          "split_on_case_change" : false 
        } 
      }
    }
  },
  "mappings" : {
    "product" : {
      "_all" : { "enabled" : false },
      "_source" : { "enabled" : true },
      "properties" : {
        "name" : { "type" : "text", "index" : "analyzed", "search_analyzer" : "productname", "analyzer" : "productname" },
        "description" : { "type" : "text", "index" : "not_analyzed" },
        "eancode" : { "type" : "text", "index" : "not_analyzed" },
        "shop" : { "type" : "text", "index" : "not_analyzed" },
        "category" : { "type" : "text", "index" : "not_analyzed" },
        "created" : { "type" : "date", "index" : "not_analyzed" },
        "timestamp" : { "type" : "date", "index" : "not_analyzed" },
        "price" : { "type" : "float", "index" : "not_analyzed" },
        "url" : { "type" : "text", "index" : "no" },
        "image" : { "type" : "text", "index" : "no" },
        "history" : {
          "properties" : {
            "timestamp" : { "type" : "date", "index" : "no" },
            "price" : { "type" : "float", "index" : "no" }
          }
        }
      }
    }
  }
}'; echo
curl -XGET "$ELASTIC_URL/_cluster/health?wait_for_status=green"

rm -rf node_modules
rm watzdprice*.tgz
npm pack ../watzdprice
mv watzdprice-*.tgz watzdprice.tgz
npm install
ELASTIC_URL=$ELASTIC_URL ELASTIC_INDEX=$ELASTIC_INDEX npm test

# docker-compose down
