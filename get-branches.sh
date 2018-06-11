#!/bin/bash

ISF='' read -r -d '' query <<-END_GQL 
query {
  repository(owner: "$GITHUB_OWNER", name: "$GITHUB_REPO") { 
    pullRequests(first:100, states:[OPEN], orderBy:{field: UPDATED_AT, direction:DESC}) { 
      pageInfo { 
        hasNextPage 
        endCursor 
      } 
      edges { 
        node { 
          headRefName 
        } 
      } 
    } 
  } 
}
END_GQL

query_json=$(jq -n --arg query "$query" '{"query": $query}')
branches_json=$(curl --silent -H "Authorization: bearer $GITHUB_KEY" -X POST -d "$query_json" https://api.github.com/graphql)

jq --raw-output '.data.repository.pullRequests.edges | .[] | .node.headRefName' <<< $branches_json

while [ $(jq --raw-output '.data.repository.pullRequests.pageInfo.hasNextPage' <<< $branches_json) = "true" ]; do
  cursor=$(jq --raw-output '.data.repository.pullRequests.pageInfo.endCursor' <<< $branches_json)
  ISF='' read -r -d '' query <<-END_GQL 
  query {
    repository(owner: "$GITHUB_OWNER", name: "$GITHUB_REPO") { 
      pullRequests(first:100, states:[OPEN], orderBy:{field: UPDATED_AT, direction:DESC} after:"$cursor") { 
        pageInfo { 
          hasNextPage 
          endCursor 
        } 
        edges { 
          node { 
            headRefName 
          } 
        } 
      } 
    } 
  }
END_GQL

  query_json=$(jq -n --arg query "$query" '{"query": $query}')
  branches_json=$(curl --silent -H "Authorization: bearer $GITHUB_KEY" -X POST -d "$query_json" https://api.github.com/graphql)

  jq --raw-output '.data.repository.pullRequests.edges | .[] | .node.headRefName' <<< $branches_json
done
