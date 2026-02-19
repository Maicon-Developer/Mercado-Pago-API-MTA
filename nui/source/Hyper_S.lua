--[[ 
╔══════════════════════════════════════════════════[ www.hyperscripts.com.br ]═════════════════════════════════════════════════════════════╗

                    ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗     ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
                    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
                    ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
                    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
                    ██║  ██║   ██║   ██║     ███████╗██║  ██║    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
                    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                               
╚══════════════════════════════════════════════════[ www.hyperscripts.com.br ]═════════════════════════════════════════════════════════════╝
--]]


-- Globals


local config = Hyper_Config
local gerais = config['globals']
local approved = false
local paymentAPI = { }
local approved_global = {
     id = 20359978,
     point_of_interaction = {
          type = "PIX";
          application_data = {
               name = "NAME_SDK",
               version = "VERSION_NUMBER",
          };
          transaction_data = {
               qr_code_base64 = "iVBORw0KGgoAAAANSUhEUgAABRQAAAUUCAYAAACu5p7o...",
               qr_code = "00020126600014br.gov.bcb.pix0117test@testuser.com0217dados adicionais...",
               ticket_url = "https://www.mercadopago.com.br/payments/123456789/ticket?caller_id=123456&hash=123e4567-e89b-12d3-a456-426655440000"
          };
     },
 }
local callback = { }
_TUNNEL.Key = 'E<vp9CE`Op@EYt24DUc+94TtQMv&3<6G'


--# Restart


outputDebugString( getResourceName(getThisResource( ))..' ↝ Carregando conteúdo, aguarde 5 segundos.', 4, 223, 188, 100 )
     local resourceName = getResourceFromName( '[HS]Assets' )
     if resourceName then
          local status = getResourceState( resourceName )
          if status == 'running' then
               assets = exports['[HS]Assets']
          elseif status == 'loaded' then
               outputDebugString('[www.hyperscripts.com.br] - Ligue nosso sistema de [HS]Assets.', 4, 255, 217, 102)
               return stopResource( getThisResource( ) )
          end
     else
          outputDebugString('[www.hyperscripts.com.br] - Não encontramos o sistema [HS]Assets carregado no servidor.', 4, 255, 58, 67)
          outputDebugString('[www.hyperscripts.com.br] - Carregue no servidor e dê um refresh no f8.', 4, 255, 217, 102)
          stopResource( getThisResource( ) )
     end
setTimer(function( )
     outputDebugString(getResourceName(getThisResource( ))..' ↝ carregado com sucesso.', 4, 166, 234, 124)
end, 1 * 1000, 1 )


-- Command


addCommandHandler( gerais['teste:api']['command'], function( player )
     local account = getAccountName( getPlayerAccount( player ) )
     if not isObjectInACLGroup( 'user.'..account, aclGetGroup( 'Console' ) ) then
          return outputDebugString( '[www.hyperscripts.com.br] - Você não tem permissão para executar este comando.', 4, 255, 58, 67 )
     end
     sendRequestAPI( player, gerais['teste:api']['send'] )
end )


-- Exports 


if gerais['timer:payments']['verify'] then
     verifyPaymentAPI = function( )
          for i, v in pairs( getElementsByType( 'player' ) ) do
               local account = getAccountName( getPlayerAccount( v ) )
               if paymentAPI[ account ] and paymentAPI[ account ]['id'] then
                    getRequestAPI( v, { payment_id = paymentAPI[ account ]['id'], resname = callback[ account ]['resname'] } )
               end
          end
     end
     setTimer( verifyPaymentAPI, gerais['timer:payments']['timer'] * gerais['timer:payments']['format'], 0 )
end


sendRequestAPI = function( player, infos )
     if player and type( infos ) == 'table' then
          local account = getAccountName( getPlayerAccount( player ) )
          if infos and infos.approved then
               paymentAPI[ account ] = approved_global;
               callback[ account ] = infos
               approved = true
               return
          end
          Client.sendLoadingAPI( false, player, infos )
          assets:outputMessage( player, 'Pix copia e cola copiado com sucesso!', 'success' )
          local value = string.format( "%.2f", tonumber( infos['amount'] ) )
          fetchRemote('https://api.mercadopago.com/v1/payments', {
               headers = {
                    ['Content-Type'] = "application/json";
                    ['Authorization'] = "Bearer "..gerais['acess:token'];
                    ['X-Idempotency-Key'] = generateString( 20 );
               },
               queueName = "POST";
               postData = '{"description": "'..infos['description']..'", "installments": '..infos['installments']..', "transaction_amount": '..tonumber(value)..', "payment_method_id": "pix", "external_reference": "'..infos['external_reference']..'", "payer": { "first_name": null,"last_name": null,"email": "'..gerais['e-mail']..'" }}'
          },
          function( resposta, erro )
               if gerais['teste:api']['debug'] then
                    outputDebugString( '[sendRequestAPI] - Resposta da API: '..resposta, 4, 166, 234, 124 )
               end
               if not erro.success then
                    closeQrcode( player )
                    return outputDebugString( '[www.hyperscripts.com.br] - Sua requisição foi mal sucedida!', 4, 201, 0, 118)
               end
               for i, v in ipairs( {fromJSON( resposta )} ) do
                    Client.sendRequestAPI( false, player, v, infos )
                    paymentAPI[ account ] = v
                    callback[ account ] = infos
                    approved = false
               end
          end
          , '', false, player )
     else
          outputDebugString('[www.hyperscripts.com.br] - Argumentos inválidos!', 4, 114, 137, 218)
     end
end



getRequestAPI = function( player, infos )
     if type( infos ) == 'table' and infos['payment_id'] and infos['resname'] then
          local account = getAccountName(getPlayerAccount( player ))
          local call = exports[ infos['resname'] ]
          if approved then
               return call:getPayment( player, { status = 'approved' }, callback[ account ] )
          end
          fetchRemote('https://api.mercadopago.com/v1/payments/'..infos['payment_id']..'?access_token='..gerais['acess:token'],
          function( resposta, error, player )
               if gerais['teste:api']['debug'] then
                    outputDebugString( '[getRequestAPI] - Resposta da API: '..resposta, 4, 166, 234, 124 )
               end
               if not error.success then
                    closeQrcode( player )
                    return outputDebugString( '[www.hyperscripts.com.br] - Sua requisição foi mal sucedida!', 4, 201, 0, 118)
               end
               for i, v in ipairs( { fromJSON( resposta ) } ) do
                    if v then
                         call:getPayment( player, v, callback[ account ] )
                    end
               end
          end, '', false, player )
     else
          outputDebugString('[www.hyperscripts.com.br] - Argumentos inválidos!', 4, 114, 137, 218)
     end
end


closeQrcode = function( player )
     local account = getAccountName(getPlayerAccount( player ))
     if paymentAPI[ account ] then
          paymentAPI[ account ] = nil
          callback[ account ] = nil
     end
     Client.closeQrCode( false, player )
end


getPaymentID = function( player )
     local account = getAccountName( getPlayerAccount( player ) )
     if paymentAPI[ account ] then
          return paymentAPI[ account ]['id'], paymentAPI[ account ]['point_of_interaction']['transaction_data']['qr_code']
     end
     return false
end


addEventHandler('onPlayerQuit', root, function( )
     local account = getAccountName(getPlayerAccount( source ))
     if paymentAPI[ account ] then
          paymentAPI[ account ] = nil
     end
end)


local allowed = { { 48, 57 }, { 65, 90 }, { 97, 122 } }

function generateString ( len )
     if tonumber ( len ) then
          math.randomseed ( getTickCount () )
          local str = ""
          for i = 1, len do
               local charlist = allowed[math.random ( 1, 3 )]
               str = str .. string.char ( math.random ( charlist[1], charlist[2] ) )
          end
          return str
     end
     return false
end


removeHex = function(str) 
     return str:gsub('#%x%x%x%x%x%x', '') 
end