import type { NextPage } from 'next';
import Head from 'next/head';
import Image from 'next/image';

import styles from '../styles/Home.module.scss';

import Layout from '../components/layout/Layout';

const Home: NextPage = () => {
   return (
      <>
         <Layout>
            <div className='container'>
               <h1>
                  CrowdUp is the ultimate crowsourcing platform, powered by
                  Ethereum
               </h1>
            </div>
         </Layout>
      </>
   );
};

export default Home;
