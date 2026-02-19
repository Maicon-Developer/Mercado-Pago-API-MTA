--[[ 
╔══════════════════════════════════════════════════[ www.hyperscripts.com.br ]═════════════════════════════════════════════════════════════╗
 ___  ___      ___    ___ ________  _______   ________          ________  ________  ________  ___  ________  _________  ________      
|\  \|\  \    |\  \  /  /|\   __  \|\  ___ \ |\   __  \        |\   ____\|\   ____\|\   __  \|\  \|\   __  \|\___   ___\\   ____\     
\ \  \\\  \   \ \  \/  / | \  \|\  \ \   __/|\ \  \|\  \       \ \  \___|\ \  \___|\ \  \|\  \ \  \ \  \|\  \|___ \  \_\ \  \___|_    
 \ \   __  \   \ \    / / \ \   ____\ \  \_|/_\ \   _  _\       \ \_____  \ \  \    \ \   _  _\ \  \ \   ____\   \ \  \ \ \_____  \   
  \ \  \ \  \   \/  /  /   \ \  \___|\ \  \_|\ \ \  \\  \|       \|____|\  \ \  \____\ \  \\  \\ \  \ \  \___|    \ \  \ \|____|\  \  
   \ \__\ \__\__/  / /      \ \__\    \ \_______\ \__\\ _\         ____\_\  \ \_______\ \__\\ _\\ \__\ \__\        \ \__\  ____\_\  \ 
    \|__|\|__|\___/ /        \|__|     \|_______|\|__|\|__|       |\_________\|_______|\|__|\|__|\|__|\|__|         \|__| |\_________\
             \|___|/                                              \|_________|                                            \|_________|
  
╚══════════════════════════════════════════════════[ www.hyperscripts.com.br ]═════════════════════════════════════════════════════════════╝
--]]


-- Globals

local config = Hyper_Config
local gerais = config['gerais']
local dxqrcode = false
local dxLoading = false
local loading = 0


-- Render


render_qrcode = function( )
     if isElement( image_qrcode ) and dados and type( dados ) == 'table' then
          dxDrawImage( parentX, parentY, dados['position'][ 1 ], dados['position'][ 2 ], dados['position'][ 3 ], dados['position'][ 4 ], image_qrcode, 0, 0, 0, tocolor( 255, 255, 255 ), true )
     end
end


render_loading = function( )
     loading = loading * 1 + 8
     dxDrawImage( parentX, parentY, dados['loading'][ 1 ], dados['loading'][ 2 ], dados['loading'][ 3 ], dados['loading'][ 4 ], 'nui/interface/loading.png', loading, 0, 0, tocolor( unpack( dados['color'] ) ), true )
end


-- Get


Client.sendLoadingAPI = function( values )
     if not util.isRender( render_loading ) then
          dados = values
          parentWidth, parentHeight = ( values['width'] * scale ), ( values['height'] * scale )
          parentX, parentY = ( screenWidth - parentWidth ) / values['x'], ( screenHeight - parentHeight ) / values['y']
          util.createRender( render_loading, 0 )
     end
end


Client.sendRequestAPI = function( infos, values )
     if not util.isRender( render_qrcode ) then
          if util.isRender( render_loading ) then
               util.destroyRender( render_loading )
          end
          if infos then
               local image = decodeString( 'base64', infos['point_of_interaction']['transaction_data']['qr_code_base64'] )
               if isElement( image_qrcode ) then
                    destroyElement( image_qrcode )
               end
               image_qrcode = dxCreateTexture( image )
               util.createRender( render_qrcode, 0 )
               dados = values
               setClipboard( infos['point_of_interaction']['transaction_data']['qr_code'] )
          end
     end
end



isQrcodeOpen = function( )
     return util.isRender( render_qrcode )
end


Client.closeQrCode = function( )
     if util.isRender( render_qrcode ) then
          if isElement( image_qrcode ) then
               destroyElement( image_qrcode )
          end
          util.destroyRender( render_qrcode )
     end
     if util.isRender( render_loading ) then
          util.destroyRender( render_loading )
     end
end