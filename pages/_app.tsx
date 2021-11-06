import '../styles/globals.scss';
import 'carbon-components/scss/globals/scss/styles.scss';
import type { AppProps } from 'next/app';

function MyApp({ Component, pageProps }: AppProps) {
   return <Component {...pageProps} />;
}

export default MyApp;
