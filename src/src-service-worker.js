import { precacheAndRoute } from 'workbox-precaching';

precacheAndRoute(self.__WB_MANIFEST);

// Para activar el SW sin esperar a que el usuario recargue la página nuevamente:
self.addEventListener('message', e => {
  if (e.data === 'skipWaiting') {
      self.skipWaiting();
  }
});