import type { NextPage } from 'next';
import Head from 'next/head';
import Image from 'next/image';

import { Grid } from 'carbon-components-react';

import styles from '../styles/Home.module.scss';

const Home: NextPage = () => {
   return (
      <>
         <Grid>
            <div className='container'>
               <h1>
                  CrowUp is the ultimate crowsourcing platform, powered by
                  Ethereum
               </h1>
            </div>
         </Grid>
      </>
   );
};

export default Home;
