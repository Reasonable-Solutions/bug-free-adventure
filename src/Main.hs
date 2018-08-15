{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-} 
{-# LANGUAGE DeriveGeneric #-} 
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
module Main where

import Data.Aeson
import Data.Char as Char
import Data.Swagger hiding (fieldLabelModifier)
import Data.Text
import GHC.Generics
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.Cors (simpleCors)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Servant
import Servant.Swagger

capitalized :: String -> String
capitalized [] = []
capitalized (head:tail) = Char.toUpper head : tail

data Daycare = Daycare { arsverkPedagogiskLeder :: Double
                       , arsverkGrunnbemanning :: Double
                       , antallBarnFraOgMed3Ar :: Double
                       , antallBarnUnder3Ar :: Double
                       , uniqueId :: Text
                       , kommune :: Text 
                       , fylke :: Text 
                       , barnehagenavn :: Text 
                       } deriving (Generic, ToSchema, Show)

instance ToJSON Daycare where
  toJSON = genericToJSON defaultOptions {
             fieldLabelModifier = capitalized }


data Daycares = Daycares [Daycare] deriving (Generic, ToSchema,ToJSON, Show)

type DayCareAPI = "barnehager" :> QueryParam "query" Text :> Get '[JSON] Daycares

type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

type DayCareIdAPI = "id" :> Get '[JSON] Daycare

type API = DayCareAPI :<|> DayCareIdAPI :<|> SwaggerAPI

fakecare = Daycare 1 2 4 1 "id" "Oslo" "Fylke" "Sokkelbarnehagen"

server :: Server API
server = let
           daycares :: Maybe Text -> Handler Daycares
           daycares query = case query of
               Nothing -> return $ Daycares [ Daycare 1 2 4 1 "id" "Oslo" "Oslo" "Oslobarnehagen"
                                            ,Daycare 1 2 4 1 "id" "Bergen" "Bergen" "Bergenbarnehagen"
                                            ,Daycare 1 2 4 1 "id" "Stavanger" "Stavanger" "Stavangarbarnehagen"
                                            , Daycare 1 2 4 1 "id" "Stockholm" "Stockholm" "Stockholmbarnehagen"

                                            ]
                            
               Just _ -> return $ Daycares [ fakecare ]
         in daycares :<|> return fakecare :<|> return (toSwagger (Proxy :: Proxy DayCareAPI))

main :: IO ()
main = run 8000 $ simpleCors $ logStdoutDev $ serve (Proxy :: Proxy API) server

testdata :: Daycares
testdata = undefined
