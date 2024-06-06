import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClientScreen extends StatefulWidget {
  const WebSocketClientScreen({super.key});

  @override
  State<WebSocketClientScreen> createState() => _WebSocketClientScreenState();
}

class _WebSocketClientScreenState extends State<WebSocketClientScreen> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8000'));
  
  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Send'),
            ),
            const SizedBox(height: 24.0),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView(
                    children: [
                      if (snapshot.hasError)
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      if (snapshot.hasData)
                        Text(
                          'Received: ${snapshot.data}',
                          style: const TextStyle(color: Colors.black),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
