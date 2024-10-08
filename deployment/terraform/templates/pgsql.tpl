---
apiVersion: v1
kind: Service
metadata:
  namespace: ${JOB_ENV}
  name: postgres
  labels:
    app: postgres
    env: ${JOB_ENV}
spec:
  type: NodePort
  ports:
    - name: pgsql-port-svc
      port: 5432
      targetPort: pgsql-port
  selector:
    app: postgres
    env: ${JOB_ENV}
---
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: ${JOB_ENV}
  name: postgres-secret
  labels:
    app: postgres
    env: ${JOB_ENV}
data:
  POSTGRES_DB: "${POSTGRES_DB}"
  POSTGRES_USER: "${POSTGRES_USER}"
  POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: ${JOB_ENV}
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
      env: ${JOB_ENV}
  template:
    metadata:
      labels:
        app: postgres
        env: ${JOB_ENV}
    spec:
      containers:
        - name: postgres
          image: 'postgres:16'
          startupProbe:
            tcpSocket:
              port: 5432
            initialDelaySeconds: 10
            failureThreshold: 10
            periodSeconds: 10
          livenessProbe:
            tcpSocket:
              port: 5432
            initialDelaySeconds: 5
            periodSeconds: 5
            timeoutSeconds: 1
            successThreshold: 1
            failureThreshold: 2
          imagePullPolicy: IfNotPresent
          ports:
            - name: pgsql-port
              containerPort: 5432
          envFrom:
            - configMapRef:
                name: postgres-secret
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: postgresdata
      volumes:
        - name: postgresdata
          persistentVolumeClaim:
            claimName: postgres-volume-claim-${JOB_ENV}
