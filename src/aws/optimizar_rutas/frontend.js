let agendado_array = JSON.parse(sessionStorage.getItem('u_Agendado_array'));

document.getElementById('optimizeRoute').addEventListener('click', async () => {
    const origin = [-122.3331, 47.6097]; // Coordenadas de origen (ejemplo)
    
    // Asegúrate de que agendado_array contenga los clientes con sus coordenadas
    const clientes = agendado_array.map(cliente => ({
        cliente_id: cliente.cliente_id,
        cli_coordenadas: cliente.cli_coordenadas // Asegúrate que esto sea un array [lon, lat]
    }));

    const response = await fetch('https://6izw9fmn59.execute-api.us-east-1.amazonaws.com/prod/optimizar', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ origin, clientes })
    });

    if (!response.ok) {
        console.error('Error en la solicitud:', response.statusText);
        return;
    }

    const data = await response.json();
    console.log('Ruta optimizada:', data);
});