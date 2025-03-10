
const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const cors = require('cors');

const app = express();
app.use(cors());

// Create HTTP server
const server = http.createServer(app);

// Create WebSocket server instance
const wss = new WebSocket.Server({ server });

// A map to hold rooms and their clients
const rooms = {};

// Broadcast to clients in the same room
wss.broadcastToRoom = (ws, room, data) => {
    if (rooms[room]) {
        rooms[room].forEach((client) => {
            if (client !== ws && client.readyState === WebSocket.OPEN) {
                client.send(data);

                console.log('------------------------------------ Outgoing Message ------------------------------------');
                console.log(data);
            }
        });
    }
};

wss.broadcast = (ws, data) => {
    wss.clients.forEach((client) => {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
            client.send(data);
        }
    });
 };

wss.on('connection', (ws) => {
    console.log(`Client connected. Total connected clients: ${wss.clients.size}`);

    let currentRoom = null;  // Track the current room for the client

    ws.onmessage = (message) => {

        console.log('------------------------------------ Incoming Message ------------------------------------');
        console.log(message.data + "\n");

        const parsedMessage = JSON.parse(message.data);
        const { type, room } = parsedMessage;

        if (type === 'join') {
            // Join a room
            if (rooms[room]) {
                rooms[room].push(ws);
            } else {
                rooms[room] = [ws];
            }
            currentRoom = room;
            console.log(`Client joined room: ${room}`);
        } else if (type === 'leave') {
            // Leave a room
            if (currentRoom && rooms[currentRoom]) {
                const index = rooms[currentRoom].indexOf(ws);
                if (index !== -1) {
                    rooms[currentRoom].splice(index, 1);
                    console.log(`Client left room: ${currentRoom}`);
                }
            }
            currentRoom = null;
        } else if (currentRoom) {
            // Broadcast message to the room
            console.log(`Broadcasting to room: ${currentRoom}`);
            wss.broadcastToRoom(ws, currentRoom, message.data);
        } else {
            // Broadcast message to the all
            console.log(`Broadcasting to all client`);
            wss.broadcast(ws, message.data);
        }
    };

    // Handle pong responses (auto reply to pings)
    ws.onping = () => {
        ws.pong();
    };

    ws.onclose = () => {
        console.log(`Client disconnected. Total connected clients: ${wss.clients.size}`);

        // Remove client from the room they are in
        if (currentRoom && rooms[currentRoom]) {
            const index = rooms[currentRoom].indexOf(ws);
            if (index !== -1) {
                rooms[currentRoom].splice(index, 1);
                console.log(`Client removed from room: ${currentRoom}`);
            }
        }
    };

    ws.onerror = (err) => {
        console.error(`WebSocket error: ${err}`);
    };
});

// Serve a simple status page
app.get('/', (req, res) => {
    res.send('WebSocket Server is running');
    console.log('WebSocket Server is running');
});

// Start server
const PORT = process.env.PORT || 8080;
server.listen(PORT, function () {
    console.log(`WebSocket server is running on port ${PORT}`);
});
