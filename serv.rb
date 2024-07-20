require 'socket'

server = TCPServer.new(3000) # Écoute sur le port 3000
chatrooms = Hash.new { |hash, key| hash[key] = [] } # Initialise les chatrooms

loop do
  client = server.accept # Attend la connexion d'un client
  Thread.start(client) do |client_connection|
    client_connection.puts "Hello! Vous êtes connecté au serveur TCP. Envoyez des messages au format 'chatroom_id:message'."
    
    while message = client_connection.gets
      chatroom_id, content = message.chomp.split(":", 2) # Extrait l'ID de la chatroom et le contenu du message
      if chatroom_id && content
        chatrooms[chatroom_id] << content
        chatrooms[chatroom_id].each do |msg|
          client_connection.puts "Message dans chatroom #{chatroom_id}: #{msg}"
        end
      else
        client_connection.puts "Format incorrect. Envoyez des messages au format 'chatroom_id:message'."
      end
    end
    
    client_connection.close
  end
end
