
function getZoomName(zoomNames) {
    var all = "azxcvbnmsdfghjklqwertyuiopZXCVBNMASDFGHJKLQWERTYUIOP0123456789";
    var b = "1111";
    while(zoomNames.includes(b)){
        b = "";
        for (var i = 0; i < 4; i++) {
            var index = Math.floor(Math.random() * 62);
            b += all.charAt(index);
      
        }
    }
    return b;
};

 function addClient(zoomName, client, zooms){
    for(let i = 0; i < zooms.length; i++){
        if(zooms[i].name === zoomName){
            client.zoomName = zoomName;
            zooms[i].clients.push(client);
            return zooms[i];
        }
    }
    return false;
}

 function mySendUTF(client, type, data){
    if(client === undefined){
        return;
    }
    try{
        client.connection.sendUTF(JSON.stringify({type:type, data:data}));
    } catch(e){

    }

}

function boardInit(board) {    
    for (var i=0;i<=6;i++)
        for (var j=0;j<=6;j++)
            for (var k=0;k<=6;k++)
                board[i][j][k]=0;
}

 function createZoom(zooms, client, zoomNames){
    let zoomName = getZoomName(zoomNames);
    let board=new Array();
    for (var i=0;i<=6;i++){
        board[i]=new Array();
        for (var j=0;j<=6;j++)
            board[i][j]=new Array();
    }
    boardInit(board);
    let zoom = {
        name: zoomName,
        clients: [client],
        board: board,
        go: 0, // 0表示改黑棋走，1表示改白棋走
        steps: 0,
        over: 0
    }
    zooms.push(zoom);
    zoomNames.push(zoomName);
    client.zoomName = zoomName;
    return zoom;
}

 function isJson(str) {
    try {
        if (typeof JSON.parse(str) == "object") {
            return true;
        }
    } catch(e) {
    }
    return false;
}

function checkWin(x,y,z, board) {
    let dir=[[0,0,1],[0,1,0],[0,1,1],[0,1,-1],[1,0,0],[1,0,1],[1,0,-1],[1,1,0],[1,-1,0],[1,1,1],[1,1,-1],[1,-1,1],[-1,1,1]];
    var down,up;
    for (var d=0;d<13;d++)
    {
        down=1;
        up=1;
        while (x+up*dir[d][0]>=0&&y+up*dir[d][1]>=0&&z+up*dir[d][2]>=0&&x+up*dir[d][0]<=6&&y+up*dir[d][1]<=6&&z+up*dir[d][2]<=6&&board[x][y][z]==board[x+up*dir[d][0]][y+up*dir[d][1]][z+up*dir[d][2]]) up++;
        while (x-down*dir[d][0]>=0&&y-down*dir[d][1]>=0&&z-down*dir[d][2]>=0&&x-down*dir[d][0]<=6&&y-down*dir[d][1]<=6&&z-down*dir[d][2]<=6&&
            board[x][y][z]==board[x-down*dir[d][0]][y-down*dir[d][1]][z-down*dir[d][2]]) down++;
        if (down+up>5)
            return 1;
    }
    return 0;
}

 function play(step, client, codes, zooms, zoomNames){
    // 不在房间里
    if(!client.zoomName || !zoomNames.includes(client.zoomName)){
        mySendUTF(client, 'ctrl', codes.zoomNotFound);
        return;
    } 
    // 不在房间里
    let zoom = undefined;
    for(let i = 0; i < zooms.length; i++){
        if(zooms[i].name === client.zoomName){
            zoom = zooms[i];
            break;
        }
    }
    if(!zoom){
        mySendUTF(client, 'ctrl', codes.zoomNotFound);
        return;
    }
    if(zoom.over){
        mySendUTF(client, 'ctrl', codes.gameOver);
        return;
    }
    let board = zoom.board;
    // 可以下棋
    if((client === zoom.clients[0] && zoom.go === 0) || (client === zoom.clients[1] && zoom.go === 1)){
        if (board[step.x][step.y][step.z]==0){
            // 步数加一
            zoom.steps ++; 
            // 在步骤中加入颜色
            step.color = zoom.go;
            // 通知所有客户端
            for (var i=0;i<zoom.clients.length;i++) {
                mySendUTF(zoom.clients[i], 'step', step);
            }
            // go为1表示该白棋走
            if (zoom.go){ 
                board[step.x][step.y][step.z]=1;
                console.log((new Date())+" Zoom : " + zoom.name  +" White walks at ("+step.x+","+step.y+","+step.z+") .");
                if (checkWin(step.x,step.y,step.z, zoom.board)){
                    for (var i=0;i<zoom.clients.length;i++) {
                        mySendUTF(zoom.clients[i], 'ctrl', codes.whiteWin);
                    }
                    console.log((new Date())+" Zoom : " + zoom.name + " White wins.");
                    zoom.over = 1;
                } else {
                    mySendUTF(zoom.clients[0],'ctrl', codes.go);
                }
            }
            else {
                board[step.x][step.y][step.z]=2;
                console.log((new Date())+" Zoom : " + zoom.name +" Black walks at ("+step.x+","+step.y+","+step.z+") .");
                if (checkWin(step.x, step.y, step.z, board)){
                    for (var i=0;i<zoom.clients.length;i++) {
                        mySendUTF(zoom.clients[i], 'ctrl', codes.blackWin);
                    }
                    console.log((new Date()) +" Zoom : " + zoom.name+" Black wins.");
                    zoom.over = 1;
                } else {
                    mySendUTF(zoom.clients[1],'ctrl', codes.go);
                }
            }
            zoom.go = 1 - zoom.go;
            if (zoom.steps==343){ // 步数过多就平局了
                for (var i=0;i<zoom.clients.length;i++) {
                    mySendUTF(zoom.clients[i], 'ctrl', codes.draw); // 平局
                }
                console.log((new Date()) +" Zoom : " + zoom.name+" Draw.");
            }
        }
    } else {
        mySendUTF(client, 'ctrl', codes.playNotAllowed);
    }


}

const codes = {
    zoomNotFound: -1,    // 进入房间找不到
    allreadyInZoom: -2,  // 创建房间时已经在房间里面了
    playNotAllowed: -3,  // 不允许你落子
    gameOver: -4,
    checkNotFound: -5,
    black: 0,
    white: 1,
    view: 2,
    go: 3,
    blackOut: 4,
    whiteOut: 5,
    draw: 6,
    whiteWin: 7,
    blackWin: 8,
    checkOk: 9

}

const config={
    serverPort: 8081,
    codes: codes
}


var webSocketsServerPort=config.serverPort;

var webSocketServer=require('websocket').server;
var http=require('http');

var zooms=[];
var zoomNames=[];

var server=http.createServer(function(request,response){});

server.listen(webSocketsServerPort,function(){
    console.log((new Date())+"Server is listening on port "+webSocketsServerPort);
});

var wsServer=new webSocketServer({
    httpServer:server
});

let orders = [ 'create', 'enter', 'play', 'check']

wsServer.on('request',function(request) {
    var client={
        connection:request.accept(null,request.origin)
    } 
    // message: create | enter{zoomName} | play{step}
    client.connection.on('message',function(message){
        if(message.type !=='utf8' || !isJson(message.utf8Data)){
            return;
        }
        var json = JSON.parse(message.utf8Data);
        if(json.order && orders.includes(json.order)){
            switch(json.order){
                case 'create': 
                    if(client.zoomName){
                        mySendUTF(client, 'ctrl', config.codes.allreadyInZoom);
                        break;
                    }
                    let zoom = createZoom(zooms, client, zoomNames);
                    console.log((new Date())+" Zoom : " + zoom.name + " Create Zoom.");
                    mySendUTF(client, 'zoom', zoom.name);
                    break;
                case 'enter':
                    if(client.zoomName){
                        mySendUTF(client, 'ctrl', config.codes.allreadyInZoom);
                        break;
                    }
                    console.log((new Date())+" Zoom : " + json.data + " Enter Zoom.");

                    if(json.data === undefined || !zoomNames.includes(json.data)){
                        mySendUTF(client, 'ctrl', config.codes.zoomNotFound);
                        break;
                    }
                    let ret = addClient(json.data, client, zooms); 
                    if(!ret || ret.over){
                        mySendUTF(client, 'ctrl', config.codes.zoomNotFound);
                        break;
                    }
                    if(ret.clients.length >= 3){   // 第三个人加入的话，就直接告诉他棋盘
                        mySendUTF(client,'ctrl', config.codes.view);
                        mySendUTF(client, 'board', ret.board);
                    } else if(ret.clients.length === 2){
                        mySendUTF(ret.clients[0],'ctrl', config.codes.go);
                        mySendUTF(ret.clients[0],'ctrl', config.codes.black);
                        mySendUTF(ret.clients[1],'ctrl', config.codes.white);
                    }
                    for(let i = 0; i < ret.clients.length; i++){
                        mySendUTF(ret.clients[i], 'number', ret.clients.length);
                    }
                    break;
                case 'play':
                    let step={x:0,y:0,z:0,blackwhite:0};
                    step.x=parseInt(json.data[0]);
                    step.y=parseInt(json.data[1]);
                    step.z=parseInt(json.data[2]);
                    play(step, client, config.codes, zooms, zoomNames);
                    break;
                case 'check':
                    console.log('check data: ' + json.zoomName,zoomNames);
                    if(json.zoomName === undefined || !zoomNames.includes(json.zoomName)){
                        mySendUTF(client, 'ctrl', config.codes.checkNotFound);
                    } else {
                        mySendUTF(client, 'ctrl', config.codes.checkOk);
                    }
            }
        }

    });



    client.connection.on('close',function(connection){

        if(!client.zoomName || !zoomNames.includes(client.zoomName)){
            // 房间不存在的话不做处理
            return;
        } 
        let zoom = undefined;
        let zoomIndex = undefined;
        for(let i = 0; i < zooms.length; i++){
            if(zooms[i].name === client.zoomName){
                zoom = zooms[i];
                zoomIndex = i;
                break;
            }
        }
        if(!zoom){
            return;
        }
        let index = undefined;
        for(let i = 0; i < zoom.clients.length; i++){
            if(client === zoom.clients[i]){
                index = i;
                zoom.clients.splice(i, 1);
                break;
            }
        }
        if(index === undefined){
            return;
        }
        for(let i = 0; i < zoom.clients.length; i++){
            mySendUTF(zoom.clients[i], 'number', zoom.clients.length);  // 通知总人数
        }

        let ctrl;
        if (index<2) {
            zoom.over = 1;
            if (zoom.clients.length==0){
                console.log((new Date())+" Zoom : " + zoom.name  +" Empty now .");
                zoomNames.splice(zoomIndex,1);
                zooms.splice(zoomIndex,1);
                return;
            }
            if (index==0){
                console.log((new Date())+" Zoom : " + zoom.name  +" Black gets out. There is "+zoom.clients.length+" people totally.");
                ctrl=4;
            } else {
                console.log((new Date())+" Zoom : " + zoom.name  +" White gets out. There is "+zoom.clients.length+" people totally.");
                ctrl=5;
            }
            for (var i=0;i<zoom.clients.length;i++){
                mySendUTF(zoom.clients[i],'ctrl',ctrl);
            } 
        }else{
            console.log((new Date())+" Zoom : " + zoom.name  +" A viewer gets out . There is "+zoom.clients.length+" people totally .");
        } 
    });
});