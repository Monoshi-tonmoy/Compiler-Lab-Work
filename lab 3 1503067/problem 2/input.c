int main()
{
     int a = 10;
     int count=0;

     while(a+10)
     {
         if(a==10)
         {
              count++;
         }
         else
         {
            a=a+10.2;
            if(a==10){count++;}
            else if(a>=20){count=a++;}
            else{a--;}
        }
    }
}

