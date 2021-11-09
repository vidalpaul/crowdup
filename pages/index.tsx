import type { NextPage } from 'next';
import Head from 'next/head';
import Image from 'next/image';

import { Grid } from 'carbon-components-react';

import styles from '../styles/Home.module.scss';

import Layout from '../components/layout/Layout';

const Home: NextPage = () => {
   return (
      <>
         <Layout>
            <Grid>
               <div className='container'>
                  <h1>
                     CrowdUp is the ultimate crowsourcing platform, powered by
                     Ethereum
                  </h1>
               </div>
            </Grid>
         </Layout>
      </>
   );
};

export default Home;
