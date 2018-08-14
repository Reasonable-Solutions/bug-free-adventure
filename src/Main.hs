{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-} 
{-# LANGUAGE DeriveGeneric #-} 
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
module Main where

import Data.Aeson
import Data.Swagger
import Data.Text
import GHC.Generics
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.Cors (simpleCors)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Servant
import Servant.Swagger


data Daycare = Daycare { arsverkPedagogiskLeder :: Double
                       , arsverkGrunnbemanning :: Double
                       , antallBarnUnder3Ar :: Double
                       , storeBarn :: Double
                       } deriving (Generic, ToSchema, ToJSON, Show)

data Daycares = Daycares [Daycare] deriving (Generic, ToSchema,ToJSON, Show)

type DayCareAPI = "barnehager" :> QueryParam "query" Text :> Get '[JSON] Daycares

type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

type API = DayCareAPI :<|> SwaggerAPI

server :: Server API
server = let
           daycares :: Maybe Text -> Handler Daycares
           daycares query = case query of
               Nothing -> return $ Daycares [(Daycare 0 0 0 0)
                                            , (Daycare 1 2 3 4)
                                            , (Daycare 1 2 3 4)
                                            , (Daycare 1 2 3 4)
                                            , (Daycare 1 2 3 4)
                                            , (Daycare 1 2 3 4)
                                            , (Daycare 1 2 3 4)
                                            , (Daycare 1 2 3 4)
                                            , (Daycare 1 2 3 4)
                                            ]
                            
               Just _ -> return $ Daycares [ (Daycare 1 2 3 4) ]
         in daycares :<|> return (toSwagger (Proxy :: Proxy DayCareAPI))

main :: IO ()
main = run 8000 $ simpleCors $ logStdoutDev $ serve (Proxy :: Proxy API) server

testdata :: Daycares
testdata = undefined
